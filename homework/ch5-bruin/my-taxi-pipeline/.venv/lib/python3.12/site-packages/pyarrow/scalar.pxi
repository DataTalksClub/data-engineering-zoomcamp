# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

import collections
import warnings
from uuid import UUID
from collections.abc import Sequence, Mapping


cdef class Scalar(_Weakrefable):
    """
    The base class for scalars.
    """

    def __init__(self):
        raise TypeError(f"Do not call {self.__class__.__name__}'s constructor directly, "
                        "use pa.scalar() instead.")

    cdef void init(self, const shared_ptr[CScalar]& wrapped):
        self.wrapped = wrapped

    @staticmethod
    cdef wrap(const shared_ptr[CScalar]& wrapped):
        cdef:
            Scalar self
            Type type_id = wrapped.get().type.get().id()
            shared_ptr[CDataType] sp_data_type = wrapped.get().type

        if type_id == _Type_NA:
            return _NULL

        if type_id not in _scalar_classes:
            raise NotImplementedError(
                "Wrapping scalar of type " + frombytes(sp_data_type.get().ToString()))

        typ = get_scalar_class_from_type(sp_data_type)
        self = typ.__new__(typ)
        self.init(wrapped)

        return self

    cdef inline shared_ptr[CScalar] unwrap(self) nogil:
        return self.wrapped

    @property
    def type(self):
        """
        Data type of the Scalar object.
        """
        return pyarrow_wrap_data_type(self.wrapped.get().type)

    @property
    def is_valid(self):
        """
        Holds a valid (non-null) value.
        """
        return self.wrapped.get().is_valid

    def cast(self, object target_type=None, safe=None, options=None, memory_pool=None):
        """
        Cast scalar value to another data type.

        See :func:`pyarrow.compute.cast` for usage.

        Parameters
        ----------
        target_type : DataType, default None
            Type to cast scalar to.
        safe : boolean, default True
            Whether to check for conversion errors such as overflow.
        options : CastOptions, default None
            Additional checks pass by CastOptions
        memory_pool : MemoryPool, optional
            memory pool to use for allocations during function execution.

        Returns
        -------
        scalar : A Scalar of the given target data type.
        """
        return _pc().cast(self, target_type, safe=safe,
                          options=options, memory_pool=memory_pool)

    def validate(self, *, full=False):
        """
        Perform validation checks.  An exception is raised if validation fails.

        By default only cheap validation checks are run.  Pass `full=True`
        for thorough validation checks (potentially O(n)).

        Parameters
        ----------
        full : bool, default False
            If True, run expensive checks, otherwise cheap checks only.

        Raises
        ------
        ArrowInvalid
        """
        if full:
            with nogil:
                check_status(self.wrapped.get().ValidateFull())
        else:
            with nogil:
                check_status(self.wrapped.get().Validate())

    def __repr__(self):
        return f'<pyarrow.{self.__class__.__name__}: {self.as_py()!r}>'

    def __str__(self):
        return str(self.as_py())

    def equals(self, Scalar other not None):
        """
        Parameters
        ----------
        other : pyarrow.Scalar

        Returns
        -------
        bool
        """
        return self.wrapped.get().Equals(other.unwrap().get()[0])

    def __eq__(self, other):
        try:
            return self.equals(other)
        except TypeError:
            return NotImplemented

    def __hash__(self):
        cdef CScalarHash hasher
        return hasher(self.wrapped)

    def __reduce__(self):
        return scalar, (self.as_py(), self.type)

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python representation.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        raise NotImplementedError()


_NULL = NA = None


cdef class NullScalar(Scalar):
    """
    Concrete class for null scalars.
    """

    def __cinit__(self):
        global NA
        if NA is not None:
            raise RuntimeError('Cannot create multiple NullScalar instances')
        self.init(shared_ptr[CScalar](new CNullScalar()))

    def __init__(self):
        pass

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python None.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        return None


_NULL = NA = NullScalar()


cdef class BooleanScalar(Scalar):
    """
    Concrete class for boolean scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python bool.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CBooleanScalar* sp = <CBooleanScalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __bool__(self):
        return self.as_py() or False

cdef class UInt8Scalar(Scalar):
    """
    Concrete class for uint8 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CUInt8Scalar* sp = <CUInt8Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class Int8Scalar(Scalar):
    """
    Concrete class for int8 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CInt8Scalar* sp = <CInt8Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class UInt16Scalar(Scalar):
    """
    Concrete class for uint16 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CUInt16Scalar* sp = <CUInt16Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class Int16Scalar(Scalar):
    """
    Concrete class for int16 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CInt16Scalar* sp = <CInt16Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class UInt32Scalar(Scalar):
    """
    Concrete class for uint32 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CUInt32Scalar* sp = <CUInt32Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class Int32Scalar(Scalar):
    """
    Concrete class for int32 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CInt32Scalar* sp = <CInt32Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class UInt64Scalar(Scalar):
    """
    Concrete class for uint64 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CUInt64Scalar* sp = <CUInt64Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class Int64Scalar(Scalar):
    """
    Concrete class for int64 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python int.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CInt64Scalar* sp = <CInt64Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __index__(self):
        return self.as_py()


cdef class HalfFloatScalar(Scalar):
    """
    Concrete class for float scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python float.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CHalfFloatScalar* sp = <CHalfFloatScalar*> self.wrapped.get()
        return PyFloat_FromHalf(sp.value) if sp.is_valid else None

    def __float__(self):
        return self.as_py()

    def __int__(self):
        return int(self.as_py())


cdef class FloatScalar(Scalar):
    """
    Concrete class for float scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python float.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CFloatScalar* sp = <CFloatScalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __float__(self):
        return self.as_py()

    def __int__(self):
        return int(float(self))


cdef class DoubleScalar(Scalar):
    """
    Concrete class for double scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python float.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CDoubleScalar* sp = <CDoubleScalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def __float__(self):
        return self.as_py()

    def __int__(self):
        return int(float(self))


cdef class Decimal32Scalar(Scalar):
    """
    Concrete class for decimal32 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python Decimal.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CDecimal32Scalar* sp = <CDecimal32Scalar*> self.wrapped.get()
            CDecimal32Type* dtype = <CDecimal32Type*> sp.type.get()
        if sp.is_valid:
            return _pydecimal.Decimal(
                frombytes(sp.value.ToString(dtype.scale()))
            )
        else:
            return None


cdef class Decimal64Scalar(Scalar):
    """
    Concrete class for decimal64 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python Decimal.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CDecimal64Scalar* sp = <CDecimal64Scalar*> self.wrapped.get()
            CDecimal64Type* dtype = <CDecimal64Type*> sp.type.get()
        if sp.is_valid:
            return _pydecimal.Decimal(
                frombytes(sp.value.ToString(dtype.scale()))
            )
        else:
            return None


cdef class Decimal128Scalar(Scalar):
    """
    Concrete class for decimal128 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python Decimal.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CDecimal128Scalar* sp = <CDecimal128Scalar*> self.wrapped.get()
            CDecimal128Type* dtype = <CDecimal128Type*> sp.type.get()
        if sp.is_valid:
            return _pydecimal.Decimal(
                frombytes(sp.value.ToString(dtype.scale()))
            )
        else:
            return None


cdef class Decimal256Scalar(Scalar):
    """
    Concrete class for decimal256 scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python Decimal.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CDecimal256Scalar* sp = <CDecimal256Scalar*> self.wrapped.get()
            CDecimal256Type* dtype = <CDecimal256Type*> sp.type.get()
        if sp.is_valid:
            return _pydecimal.Decimal(
                frombytes(sp.value.ToString(dtype.scale()))
            )
        else:
            return None


cdef class Date32Scalar(Scalar):
    """
    Concrete class for date32 scalars.
    """

    @property
    def value(self):
        cdef CDate32Scalar* sp = <CDate32Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python datetime.datetime instance.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CDate32Scalar* sp = <CDate32Scalar*> self.wrapped.get()

        if sp.is_valid:
            # shift to seconds since epoch
            return (
                datetime.date(1970, 1, 1) + datetime.timedelta(days=sp.value)
            )
        else:
            return None


cdef class Date64Scalar(Scalar):
    """
    Concrete class for date64 scalars.
    """

    @property
    def value(self):
        cdef CDate64Scalar* sp = <CDate64Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python datetime.datetime instance.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef CDate64Scalar* sp = <CDate64Scalar*> self.wrapped.get()

        if sp.is_valid:
            return (
                datetime.date(1970, 1, 1) +
                datetime.timedelta(days=sp.value / 86400000)
            )
        else:
            return None


def _datetime_from_int(int64_t value, TimeUnit unit, tzinfo=None):
    if unit == TimeUnit_SECOND:
        delta = datetime.timedelta(seconds=value)
    elif unit == TimeUnit_MILLI:
        delta = datetime.timedelta(milliseconds=value)
    elif unit == TimeUnit_MICRO:
        delta = datetime.timedelta(microseconds=value)
    else:
        # TimeUnit_NANO: prefer pandas timestamps if available
        if _pandas_api.have_pandas:
            return _pandas_api.pd.Timestamp(value, tz=tzinfo, unit='ns')
        # otherwise safely truncate to microsecond resolution datetime
        if value % 1000 != 0:
            raise ValueError(
                f"Nanosecond resolution temporal type {value} is not safely "
                "convertible to microseconds to convert to datetime.datetime. "
                "Install pandas to return as Timestamp with nanosecond "
                "support or access the .value attribute."
            )
        delta = datetime.timedelta(microseconds=value // 1000)

    dt = datetime.datetime(1970, 1, 1) + delta
    # adjust timezone if set to the datatype
    if tzinfo is not None:
        dt = dt.replace(tzinfo=datetime.timezone.utc).astimezone(tzinfo)

    return dt


cdef class Time32Scalar(Scalar):
    """
    Concrete class for time32 scalars.
    """

    @property
    def value(self):
        cdef CTime32Scalar* sp = <CTime32Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python datetime.timedelta instance.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CTime32Scalar* sp = <CTime32Scalar*> self.wrapped.get()
            CTime32Type* dtype = <CTime32Type*> sp.type.get()

        if sp.is_valid:
            return _datetime_from_int(sp.value, unit=dtype.unit()).time()
        else:
            return None


cdef class Time64Scalar(Scalar):
    """
    Concrete class for time64 scalars.
    """

    @property
    def value(self):
        cdef CTime64Scalar* sp = <CTime64Scalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python datetime.timedelta instance.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CTime64Scalar* sp = <CTime64Scalar*> self.wrapped.get()
            CTime64Type* dtype = <CTime64Type*> sp.type.get()

        if sp.is_valid:
            return _datetime_from_int(sp.value, unit=dtype.unit()).time()
        else:
            return None


cdef class TimestampScalar(Scalar):
    """
    Concrete class for timestamp scalars.
    """

    @property
    def value(self):
        cdef CTimestampScalar* sp = <CTimestampScalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Pandas Timestamp instance (if units are
        nanoseconds and pandas is available), otherwise as a Python
        datetime.datetime instance.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CTimestampScalar* sp = <CTimestampScalar*> self.wrapped.get()
            CTimestampType* dtype = <CTimestampType*> sp.type.get()

        if not sp.is_valid:
            return None

        if not dtype.timezone().empty():
            tzinfo = string_to_tzinfo(frombytes(dtype.timezone()))
        else:
            tzinfo = None

        return _datetime_from_int(sp.value, unit=dtype.unit(), tzinfo=tzinfo)

    def __repr__(self):
        """
        Return the representation of TimestampScalar using `strftime` to avoid
        original repr datetime values being out of range.
        """
        cdef:
            CTimestampScalar* sp = <CTimestampScalar*> self.wrapped.get()
            CTimestampType* dtype = <CTimestampType*> sp.type.get()

        if not dtype.timezone().empty():
            type_format = str(_pc().strftime(self, format="%Y-%m-%dT%H:%M:%S%z"))
        else:
            type_format = str(_pc().strftime(self))
        return f'<pyarrow.{self.__class__.__name__}: {type_format!r}>'


cdef class DurationScalar(Scalar):
    """
    Concrete class for duration scalars.
    """

    @property
    def value(self):
        cdef CDurationScalar* sp = <CDurationScalar*> self.wrapped.get()
        return sp.value if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Pandas Timedelta instance (if units are
        nanoseconds and pandas is available), otherwise as a Python
        datetime.timedelta instance.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            CDurationScalar* sp = <CDurationScalar*> self.wrapped.get()
            CDurationType* dtype = <CDurationType*> sp.type.get()
            TimeUnit unit = dtype.unit()

        if not sp.is_valid:
            return None

        if unit == TimeUnit_SECOND:
            return datetime.timedelta(seconds=sp.value)
        elif unit == TimeUnit_MILLI:
            return datetime.timedelta(milliseconds=sp.value)
        elif unit == TimeUnit_MICRO:
            return datetime.timedelta(microseconds=sp.value)
        else:
            # TimeUnit_NANO: prefer pandas timestamps if available
            if _pandas_api.have_pandas:
                return _pandas_api.pd.Timedelta(sp.value, unit='ns')
            # otherwise safely truncate to microsecond resolution timedelta
            if sp.value % 1000 != 0:
                raise ValueError(
                    f"Nanosecond duration {sp.value} is not safely convertible to "
                    "microseconds to convert to datetime.timedelta. Install "
                    "pandas to return as Timedelta with nanosecond support or "
                    "access the .value attribute."
                )
            return datetime.timedelta(microseconds=sp.value // 1000)


cdef class MonthDayNanoIntervalScalar(Scalar):
    """
    Concrete class for month, day, nanosecond interval scalars.
    """

    @property
    def value(self):
        """
        Same as self.as_py()
        """
        return self.as_py()

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a pyarrow.MonthDayNano.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        cdef:
            PyObject* val
            CMonthDayNanoIntervalScalar* scalar
        scalar = <CMonthDayNanoIntervalScalar*>self.wrapped.get()
        val = GetResultValue(MonthDayNanoIntervalScalarToPyObject(
            deref(scalar)))
        return PyObject_to_object(val)


cdef class BinaryScalar(Scalar):
    """
    Concrete class for binary-like scalars.
    """

    def as_buffer(self):
        """
        Return a view over this value as a Buffer object.
        """
        cdef CBaseBinaryScalar* sp = <CBaseBinaryScalar*> self.wrapped.get()
        return pyarrow_wrap_buffer(sp.value) if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python bytes.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        buffer = self.as_buffer()
        return None if buffer is None else buffer.to_pybytes()

    def __bytes__(self):
        return self.as_py()

    def __getbuffer__(self, cp.Py_buffer* buffer, int flags):
        buf = self.as_buffer()
        if buf is None:
            raise ValueError("Cannot export buffer from null Arrow Scalar")
        cp.PyObject_GetBuffer(buf, buffer, flags)


cdef class LargeBinaryScalar(BinaryScalar):
    pass


cdef class FixedSizeBinaryScalar(BinaryScalar):
    pass


cdef class StringScalar(BinaryScalar):
    """
    Concrete class for string-like (utf8) scalars.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python string.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        buffer = self.as_buffer()
        return None if buffer is None else str(buffer, 'utf8')


cdef class LargeStringScalar(StringScalar):
    pass


cdef class BinaryViewScalar(BinaryScalar):
    pass


cdef class StringViewScalar(StringScalar):
    pass


cdef class ListScalar(Scalar, Sequence):
    """
    Concrete class for list-like scalars.
    """

    @property
    def values(self):
        cdef CBaseListScalar* sp = <CBaseListScalar*> self.wrapped.get()
        if sp.is_valid:
            return pyarrow_wrap_array(sp.value)
        else:
            return None

    def __len__(self):
        """
        Return the number of values.
        """
        return len(self.values)

    def __getitem__(self, i):
        """
        Return the value at the given index.
        """
        return self.values[_normalize_index(i, len(self))]

    def __iter__(self):
        """
        Iterate over this element's values.
        """
        return iter(self.values)

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python list.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        arr = self.values
        return None if arr is None else arr.to_pylist(maps_as_pydicts=maps_as_pydicts)


cdef class FixedSizeListScalar(ListScalar):
    pass


cdef class LargeListScalar(ListScalar):
    pass


cdef class ListViewScalar(ListScalar):
    pass


cdef class LargeListViewScalar(ListScalar):
    pass


cdef class StructScalar(Scalar, Mapping):
    """
    Concrete class for struct scalars.
    """

    def __len__(self):
        cdef CStructScalar* sp = <CStructScalar*> self.wrapped.get()
        return sp.value.size()

    def __iter__(self):
        cdef:
            CStructScalar* sp = <CStructScalar*> self.wrapped.get()
            CStructType* dtype = <CStructType*> sp.type.get()
            vector[shared_ptr[CField]] fields = dtype.fields()

        for i in range(dtype.num_fields()):
            yield frombytes(fields[i].get().name())

    def items(self):
        return ((key, self[i]) for i, key in enumerate(self))

    def __contains__(self, key):
        return key in list(self)

    def __getitem__(self, key):
        """
        Return the child value for the given field.

        Parameters
        ----------
        index : Union[int, str]
            Index / position or name of the field.

        Returns
        -------
        result : Scalar
        """
        cdef:
            CFieldRef ref
            CStructScalar* sp = <CStructScalar*> self.wrapped.get()

        if isinstance(key, (bytes, str)):
            ref = CFieldRef(<c_string> tobytes(key))
        elif isinstance(key, int):
            ref = CFieldRef(<int> key)
        else:
            raise TypeError('Expected integer or string index')

        try:
            return Scalar.wrap(GetResultValue(sp.field(ref)))
        except ArrowInvalid as exc:
            if isinstance(key, int):
                raise IndexError(key) from exc
            else:
                raise KeyError(key) from exc

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python dict.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        if self.is_valid:
            try:
                return {k: self[k].as_py(maps_as_pydicts=maps_as_pydicts) for k in self.keys()}
            except KeyError:
                raise ValueError(
                    "Converting to Python dictionary is not supported when "
                    "duplicate field names are present")
        else:
            return None

    def _as_py_tuple(self):
        # a version that returns a tuple instead of dict to support repr/str
        # with the presence of duplicate field names
        if self.is_valid:
            return [(key, self[i].as_py()) for i, key in enumerate(self)]
        else:
            return None

    def __repr__(self):
        return f'<pyarrow.{self.__class__.__name__}: {self._as_py_tuple()!r}>'

    def __str__(self):
        return str(self._as_py_tuple())


cdef class MapScalar(ListScalar, Mapping):
    """
    Concrete class for map scalars.
    """

    def __getitem__(self, i):
        """
        Return the value at the given index or key.
        """

        arr = self.values
        if arr is None:
            raise IndexError(i) if isinstance(i, int) else KeyError(i)

        key_field = self.type.key_field.name
        item_field = self.type.item_field.name

        if isinstance(i, (bytes, str)):
            try:
                key_index = list(self.keys()).index(i)
            except ValueError:
                raise KeyError(i)

            dct = arr[_normalize_index(key_index, len(arr))]
            return dct[item_field]

        dct = arr[_normalize_index(i, len(arr))]
        return (dct[key_field], dct[item_field])

    def __iter__(self):
        """
        Iterate over this element's values.
        """
        arr = self.values
        if arr is None:
            return
        for k, v in zip(arr.field(self.type.key_field.name), arr.field(self.type.item_field.name)):
            yield (k.as_py(), v.as_py())

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this value as a Python list or dict, depending on 'maps_as_pydicts'.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        if maps_as_pydicts not in (None, "lossy", "strict"):
            raise ValueError(
                "Invalid value for 'maps_as_pydicts': "
                + "valid values are 'lossy', 'strict' or `None` (default). "
                + f"Received {maps_as_pydicts!r}."
            )
        if not self.is_valid:
            return None
        if not maps_as_pydicts:
            return list(self)
        result_dict = {}
        if self.values is None:
            return result_dict

        for key, value in zip(self.keys(), self.values.field(self.type.item_field.name)):
            if key in result_dict:
                if maps_as_pydicts == "strict":
                    raise KeyError(
                        "Converting to Python dictionary is not supported in strict mode "
                        f"when duplicate keys are present (duplicate key was '{key}')."
                    )
                else:
                    warnings.warn(
                        f"Encountered key '{key}' which was already encountered.")
            result_dict[key] = value.as_py(maps_as_pydicts=maps_as_pydicts)
        return result_dict

    def keys(self):
        """
        Return the keys of the map as a list.
        """
        arr = self.values
        if arr is None:
            return []
        key_field = self.type.key_field.name
        return [k.as_py() for k in arr.field(key_field)]


cdef class DictionaryScalar(Scalar):
    """
    Concrete class for dictionary-encoded scalars.
    """

    @staticmethod
    def _reconstruct(type, is_valid, index, dictionary):
        cdef:
            CDictionaryScalarIndexAndDictionary value
            shared_ptr[CDictionaryScalar] wrapped
            DataType type_
            Scalar index_
            Array dictionary_

        type_ = ensure_type(type, allow_none=False)
        if not isinstance(type_, DictionaryType):
            raise TypeError('Must pass a DictionaryType instance')

        if isinstance(index, Scalar):
            if not index.type.equals(type.index_type):
                raise TypeError("The Scalar value passed as index must have "
                                "identical type to the dictionary type's "
                                "index_type")
            index_ = index
        else:
            index_ = scalar(index, type=type_.index_type)

        if isinstance(dictionary, Array):
            if not dictionary.type.equals(type.value_type):
                raise TypeError("The Array passed as dictionary must have "
                                "identical type to the dictionary type's "
                                "value_type")
            dictionary_ = dictionary
        else:
            dictionary_ = array(dictionary, type=type_.value_type)

        value.index = pyarrow_unwrap_scalar(index_)
        value.dictionary = pyarrow_unwrap_array(dictionary_)

        wrapped = make_shared[CDictionaryScalar](
            value, pyarrow_unwrap_data_type(type_), <c_bool>(is_valid)
        )
        return Scalar.wrap(<shared_ptr[CScalar]> wrapped)

    def __reduce__(self):
        return DictionaryScalar._reconstruct, (
            self.type, self.is_valid, self.index, self.dictionary
        )

    @property
    def index(self):
        """
        Return this value's underlying index as a scalar.
        """
        cdef CDictionaryScalar* sp = <CDictionaryScalar*> self.wrapped.get()
        return Scalar.wrap(sp.value.index)

    @property
    def value(self):
        """
        Return the encoded value as a scalar.
        """
        cdef CDictionaryScalar* sp = <CDictionaryScalar*> self.wrapped.get()
        return Scalar.wrap(GetResultValue(sp.GetEncodedValue()))

    @property
    def dictionary(self):
        cdef CDictionaryScalar* sp = <CDictionaryScalar*> self.wrapped.get()
        return pyarrow_wrap_array(sp.value.dictionary)

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this encoded value as a Python object.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        return self.value.as_py(maps_as_pydicts=maps_as_pydicts) if self.is_valid else None


cdef class RunEndEncodedScalar(Scalar):
    """
    Concrete class for RunEndEncoded scalars.
    """
    @property
    def value(self):
        """
        Return underlying value as a scalar.
        """
        cdef CRunEndEncodedScalar* sp = <CRunEndEncodedScalar*> self.wrapped.get()
        return Scalar.wrap(sp.value)

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return underlying value as a Python object.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        return self.value.as_py(maps_as_pydicts=maps_as_pydicts)


cdef class UnionScalar(Scalar):
    """
    Concrete class for Union scalars.
    """

    @property
    def value(self):
        """
        Return underlying value as a scalar.
        """
        cdef CSparseUnionScalar* sp
        cdef CDenseUnionScalar* dp
        if self.type.id == _Type_SPARSE_UNION:
            sp = <CSparseUnionScalar*> self.wrapped.get()
            return Scalar.wrap(sp.value[sp.child_id]) if sp.is_valid else None
        else:
            dp = <CDenseUnionScalar*> self.wrapped.get()
            return Scalar.wrap(dp.value) if dp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return underlying value as a Python object.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        value = self.value
        return None if value is None else value.as_py(maps_as_pydicts=maps_as_pydicts)

    @property
    def type_code(self):
        """
        Return the union type code for this scalar.
        """
        cdef CUnionScalar* sp = <CUnionScalar*> self.wrapped.get()
        return sp.type_code


cdef class ExtensionScalar(Scalar):
    """
    Concrete class for Extension scalars.
    """

    @property
    def value(self):
        """
        Return storage value as a scalar.
        """
        cdef CExtensionScalar* sp = <CExtensionScalar*> self.wrapped.get()
        return Scalar.wrap(sp.value) if sp.is_valid else None

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this scalar as a Python object.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            The default behavior (`None`), is to convert Arrow Map arrays to
            Python association lists (list-of-tuples) in the same order as the
            Arrow Map, as in [(key1, value1), (key2, value2), ...].

            If 'lossy' or 'strict', convert Arrow Map arrays to native Python dicts.

            If 'lossy', whenever duplicate keys are detected, a warning will be printed.
            The last seen value of a duplicate key will be in the Python dictionary.
            If 'strict', this instead results in an exception being raised when detected.
        """
        return None if self.value is None else self.value.as_py(maps_as_pydicts=maps_as_pydicts)

    @staticmethod
    def from_storage(BaseExtensionType typ, value):
        """
        Construct ExtensionScalar from type and storage value.

        Parameters
        ----------
        typ : DataType
            The extension type for the result scalar.
        value : object
            The storage value for the result scalar.

        Returns
        -------
        ext_scalar : ExtensionScalar
        """
        cdef:
            shared_ptr[CExtensionScalar] sp_scalar
            shared_ptr[CScalar] sp_storage
            CExtensionScalar* ext_scalar

        if value is None:
            storage = None
        elif isinstance(value, Scalar):
            if value.type != typ.storage_type:
                raise TypeError(f"Incompatible storage type {value.type} "
                                f"for extension type {typ}")
            storage = value
        else:
            storage = scalar(value, typ.storage_type)

        cdef c_bool is_valid = storage is not None and storage.is_valid
        if is_valid:
            sp_storage = pyarrow_unwrap_scalar(storage)
        else:
            sp_storage = MakeNullScalar((<DataType> typ.storage_type).sp_type)
        sp_scalar = make_shared[CExtensionScalar](sp_storage, typ.sp_type,
                                                  is_valid)
        with nogil:
            check_status(sp_scalar.get().Validate())
        return pyarrow_wrap_scalar(<shared_ptr[CScalar]> sp_scalar)


class JsonScalar(ExtensionScalar):
    """
    Concrete class for JSON extension scalar.
    """


class UuidScalar(ExtensionScalar):
    """
    Concrete class for Uuid extension scalar.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this scalar as a Python UUID.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        return None if self.value is None else UUID(bytes=self.value.as_py())


cdef class FixedShapeTensorScalar(ExtensionScalar):
    """
    Concrete class for fixed shape tensor extension scalar.
    """

    def to_numpy(self):
        """
        Convert fixed shape tensor scalar to a numpy.ndarray.

        The resulting ndarray's shape matches the permuted shape of the
        fixed shape tensor scalar.
        The conversion is zero-copy.

        Returns
        -------
        numpy.ndarray
        """
        return self.to_tensor().to_numpy()

    def to_tensor(self):
        """
        Convert fixed shape tensor extension scalar to a pyarrow.Tensor, using shape
        and strides derived from corresponding FixedShapeTensorType.

        The conversion is zero-copy.

        Returns
        -------
        pyarrow.Tensor
            Tensor represented stored in FixedShapeTensorScalar.
        """
        cdef:
            CFixedShapeTensorType* c_type = static_pointer_cast[CFixedShapeTensorType, CDataType](
                self.wrapped.get().type).get()
            shared_ptr[CExtensionScalar] scalar = static_pointer_cast[CExtensionScalar, CScalar](self.wrapped)
            shared_ptr[CTensor] ctensor

        with nogil:
            ctensor = GetResultValue(c_type.MakeTensor(scalar))
        return pyarrow_wrap_tensor(ctensor)


cdef class OpaqueScalar(ExtensionScalar):
    """
    Concrete class for opaque extension scalar.
    """


cdef class Bool8Scalar(ExtensionScalar):
    """
    Concrete class for bool8 extension scalar.
    """

    def as_py(self, *, maps_as_pydicts=None):
        """
        Return this scalar as a Python object.

        Parameters
        ----------
        maps_as_pydicts : str, optional, default `None`
            Valid values are `None`, 'lossy', or 'strict'.
            This parameter is ignored for non-nested Scalars.
        """
        py_val = super().as_py()
        return None if py_val is None else py_val != 0

cdef dict _scalar_classes = {
    _Type_BOOL: BooleanScalar,
    _Type_UINT8: UInt8Scalar,
    _Type_UINT16: UInt16Scalar,
    _Type_UINT32: UInt32Scalar,
    _Type_UINT64: UInt64Scalar,
    _Type_INT8: Int8Scalar,
    _Type_INT16: Int16Scalar,
    _Type_INT32: Int32Scalar,
    _Type_INT64: Int64Scalar,
    _Type_HALF_FLOAT: HalfFloatScalar,
    _Type_FLOAT: FloatScalar,
    _Type_DOUBLE: DoubleScalar,
    _Type_DECIMAL32: Decimal32Scalar,
    _Type_DECIMAL64: Decimal64Scalar,
    _Type_DECIMAL128: Decimal128Scalar,
    _Type_DECIMAL256: Decimal256Scalar,
    _Type_DATE32: Date32Scalar,
    _Type_DATE64: Date64Scalar,
    _Type_TIME32: Time32Scalar,
    _Type_TIME64: Time64Scalar,
    _Type_TIMESTAMP: TimestampScalar,
    _Type_DURATION: DurationScalar,
    _Type_BINARY: BinaryScalar,
    _Type_LARGE_BINARY: LargeBinaryScalar,
    _Type_FIXED_SIZE_BINARY: FixedSizeBinaryScalar,
    _Type_BINARY_VIEW: BinaryViewScalar,
    _Type_STRING: StringScalar,
    _Type_LARGE_STRING: LargeStringScalar,
    _Type_STRING_VIEW: StringViewScalar,
    _Type_LIST: ListScalar,
    _Type_LARGE_LIST: LargeListScalar,
    _Type_FIXED_SIZE_LIST: FixedSizeListScalar,
    _Type_LIST_VIEW: ListViewScalar,
    _Type_LARGE_LIST_VIEW: LargeListViewScalar,
    _Type_STRUCT: StructScalar,
    _Type_MAP: MapScalar,
    _Type_DICTIONARY: DictionaryScalar,
    _Type_RUN_END_ENCODED: RunEndEncodedScalar,
    _Type_SPARSE_UNION: UnionScalar,
    _Type_DENSE_UNION: UnionScalar,
    _Type_INTERVAL_MONTH_DAY_NANO: MonthDayNanoIntervalScalar,
    _Type_EXTENSION: ExtensionScalar,
}


cdef object get_scalar_class_from_type(
        const shared_ptr[CDataType]& sp_data_type):
    cdef CDataType* data_type = sp_data_type.get()
    if data_type == NULL:
        raise ValueError('Scalar data type was NULL')

    if data_type.id() == _Type_EXTENSION:
        py_ext_data_type = pyarrow_wrap_data_type(sp_data_type)
        return py_ext_data_type.__arrow_ext_scalar_class__()
    else:
        return _scalar_classes[data_type.id()]


def scalar(value, type=None, *, from_pandas=None, MemoryPool memory_pool=None):
    """
    Create a pyarrow.Scalar instance from a Python object.

    Parameters
    ----------
    value : Any
        Python object coercible to arrow's type system.
    type : pyarrow.DataType
        Explicit type to attempt to coerce to, otherwise will be inferred from
        the value.
    from_pandas : bool, default None
        Use pandas's semantics for inferring nulls from values in
        ndarray-like data. Defaults to False if not passed explicitly by user,
        or True if a pandas object is passed in.
    memory_pool : pyarrow.MemoryPool, optional
        If not passed, will allocate memory from the currently-set default
        memory pool.

    Returns
    -------
    scalar : pyarrow.Scalar

    Examples
    --------
    >>> import pyarrow as pa

    >>> pa.scalar(42)
    <pyarrow.Int64Scalar: 42>

    >>> pa.scalar("string")
    <pyarrow.StringScalar: 'string'>

    >>> pa.scalar([1, 2])
    <pyarrow.ListScalar: [1, 2]>

    >>> pa.scalar([1, 2], type=pa.list_(pa.int16()))
    <pyarrow.ListScalar: [1, 2]>
    """
    cdef:
        DataType ty
        PyConversionOptions options
        shared_ptr[CScalar] scalar
        shared_ptr[CArray] array
        shared_ptr[CChunkedArray] chunked
        bint is_pandas_object = False
        CMemoryPool* pool

    type = ensure_type(type, allow_none=True)
    pool = maybe_unbox_memory_pool(memory_pool)

    extension_type = None
    if type is not None and type.id == _Type_EXTENSION:
        extension_type = type
        type = type.storage_type

    if _is_array_like(value):
        value = get_values(value, &is_pandas_object)

    options.size = 1

    if type is not None:
        ty = ensure_type(type)
        options.type = ty.sp_type

    if from_pandas is None:
        options.from_pandas = is_pandas_object
    else:
        options.from_pandas = from_pandas

    value = [value]
    with nogil:
        chunked = GetResultValue(ConvertPySequence(value, None, options, pool))

    # get the first chunk
    assert chunked.get().num_chunks() == 1
    array = chunked.get().chunk(0)

    # retrieve the scalar from the first position
    scalar = GetResultValue(array.get().GetScalar(0))
    result = Scalar.wrap(scalar)

    if extension_type is not None:
        result = ExtensionScalar.from_storage(extension_type, result)
    return result
