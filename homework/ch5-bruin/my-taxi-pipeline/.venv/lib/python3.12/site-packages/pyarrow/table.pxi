
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

from cpython.pycapsule cimport PyCapsule_CheckExact, PyCapsule_GetPointer, PyCapsule_New

import warnings
from cython import sizeof

cdef class ChunkedArray(_PandasConvertible):
    """
    An array-like composed from a (possibly empty) collection of pyarrow.Arrays

    Warnings
    --------
    Do not call this class's constructor directly.

    Examples
    --------
    To construct a ChunkedArray object use :func:`pyarrow.chunked_array`:

    >>> import pyarrow as pa
    >>> pa.chunked_array([], type=pa.int8())
    <pyarrow.lib.ChunkedArray object at ...>
    [
    ...
    ]

    >>> pa.chunked_array([[2, 2, 4], [4, 5, 100]])
    <pyarrow.lib.ChunkedArray object at ...>
    [
      [
        2,
        2,
        4
      ],
      [
        4,
        5,
        100
      ]
    ]
    >>> isinstance(pa.chunked_array([[2, 2, 4], [4, 5, 100]]), pa.ChunkedArray)
    True
    """

    def __cinit__(self):
        self.chunked_array = NULL
        self._init_is_cpu = False

    def __init__(self):
        raise TypeError("Do not call ChunkedArray's constructor directly, use "
                        "`chunked_array` function instead.")

    cdef void init(self, const shared_ptr[CChunkedArray]& chunked_array):
        self.sp_chunked_array = chunked_array
        self.chunked_array = chunked_array.get()

    def __reduce__(self):
        self._assert_cpu()
        return chunked_array, (self.chunks, self.type)

    @property
    def data(self):
        import warnings
        warnings.warn("Calling .data on ChunkedArray is provided for "
                      "compatibility after Column was removed, simply drop "
                      "this attribute", FutureWarning)
        return self

    @property
    def type(self):
        """
        Return data type of a ChunkedArray.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs.type
        DataType(int64)
        """
        return pyarrow_wrap_data_type(self.sp_chunked_array.get().type())

    def length(self):
        """
        Return length of a ChunkedArray.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs.length()
        6
        """
        return self.chunked_array.length()

    def __len__(self):
        return self.length()

    def __repr__(self):
        type_format = object.__repr__(self)
        return f"{type_format}\n{self}"

    def to_string(self, *, int indent=0, int window=5, int container_window=2,
                  c_bool skip_new_lines=False, int element_size_limit=100):
        """
        Render a "pretty-printed" string representation of the ChunkedArray

        Parameters
        ----------
        indent : int
            How much to indent right the content of the array,
            by default ``0``.
        window : int
            How many items to preview within each chunk at the begin and end
            of the chunk when the chunk is bigger than the window.
            The other elements will be ellipsed.
        container_window : int
            How many chunks to preview at the begin and end
            of the array when the array is bigger than the window.
            The other elements will be ellipsed.
            This setting also applies to list columns.
        skip_new_lines : bool
            If the array should be rendered as a single line of text
            or if each element should be on its own line.
        element_size_limit : int, default 100
            Maximum number of characters of a single element before it is truncated.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs.to_string(skip_new_lines=True)
        '[[2,2,4],[4,5,100]]'
        """
        cdef:
            c_string result
            PrettyPrintOptions options

        with nogil:
            options = PrettyPrintOptions(indent, window)
            options.skip_new_lines = skip_new_lines
            options.container_window = container_window
            options.element_size_limit = element_size_limit
            check_status(
                PrettyPrint(
                    deref(self.chunked_array),
                    options,
                    &result
                )
            )

        return frombytes(result, safe=True)

    def format(self, **kwargs):
        """
        DEPRECATED, use pyarrow.ChunkedArray.to_string

        Parameters
        ----------
        **kwargs : dict

        Returns
        -------
        str
        """
        import warnings
        warnings.warn('ChunkedArray.format is deprecated, '
                      'use ChunkedArray.to_string')
        return self.to_string(**kwargs)

    def __str__(self):
        return self.to_string()

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
            self._assert_cpu()
            with nogil:
                check_status(self.sp_chunked_array.get().ValidateFull())
        else:
            with nogil:
                check_status(self.sp_chunked_array.get().Validate())

    @property
    def null_count(self):
        """
        Number of null entries

        Returns
        -------
        int

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.null_count
        1
        """
        self._assert_cpu()
        return self.chunked_array.null_count()

    @property
    def nbytes(self):
        """
        Total number of bytes consumed by the elements of the chunked array.

        In other words, the sum of bytes from all buffer ranges referenced.

        Unlike `get_total_buffer_size` this method will account for array
        offsets.

        If buffers are shared between arrays then the shared
        portion will only be counted multiple times.

        The dictionary of dictionary arrays will always be counted in their
        entirety even if the array only references a portion of the dictionary.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.nbytes
        49
        """
        self._assert_cpu()
        cdef:
            CResult[int64_t] c_res_buffer

        with nogil:
            c_res_buffer = ReferencedBufferSize(deref(self.chunked_array))
            size = GetResultValue(c_res_buffer)
        return size

    def get_total_buffer_size(self):
        """
        The sum of bytes in each buffer referenced by the chunked array.

        An array may only reference a portion of a buffer.
        This method will overestimate in this case and return the
        byte size of the entire buffer.

        If a buffer is referenced multiple times then it will
        only be counted once.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.get_total_buffer_size()
        49
        """
        self._assert_cpu()
        cdef:
            int64_t total_buffer_size

        total_buffer_size = TotalBufferSize(deref(self.chunked_array))
        return total_buffer_size

    def __sizeof__(self):
        return super(ChunkedArray, self).__sizeof__() + self.nbytes

    def __iter__(self):
        for chunk in self.iterchunks():
            for item in chunk:
                yield item

    def __getitem__(self, key):
        """
        Slice or return value at given index

        Parameters
        ----------
        key : integer or slice
            Slices with step not equal to 1 (or None) will produce a copy
            rather than a zero-copy view

        Returns
        -------
        value : Scalar (index) or ChunkedArray (slice)
        """
        self._assert_cpu()
        if isinstance(key, slice):
            return _normalize_slice(self, key)

        return self.getitem(_normalize_index(key, self.chunked_array.length()))

    cdef getitem(self, int64_t i):
        self._assert_cpu()
        return Scalar.wrap(GetResultValue(self.chunked_array.GetScalar(i)))

    def is_null(self, *, nan_is_null=False):
        """
        Return boolean array indicating the null values.

        Parameters
        ----------
        nan_is_null : bool (optional, default False)
            Whether floating-point NaN values should also be considered null.

        Returns
        -------
        array : boolean Array or ChunkedArray

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.is_null()
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            false,
            false,
            false,
            false,
            true,
            false
          ]
        ]
        """
        self._assert_cpu()
        options = _pc().NullOptions(nan_is_null=nan_is_null)
        return _pc().call_function('is_null', [self], options)

    def is_nan(self):
        """
        Return boolean array indicating the NaN values.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import numpy as np
        >>> arr = pa.chunked_array([[2, np.nan, 4], [4, None, 100]])
        >>> arr.is_nan()
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            false,
            true,
            false,
            false,
            null,
            false
          ]
        ]
        """
        self._assert_cpu()
        return _pc().is_nan(self)

    def is_valid(self):
        """
        Return boolean array indicating the non-null values.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.is_valid()
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            true,
            true,
            true
          ],
          [
            true,
            false,
            true
          ]
        ]
        """
        self._assert_cpu()
        return _pc().is_valid(self)

    def __eq__(self, other):
        try:
            return self.equals(other)
        except TypeError:
            return NotImplemented

    def fill_null(self, fill_value):
        """
        Replace each null element in values with fill_value.

        See :func:`pyarrow.compute.fill_null` for full usage.

        Parameters
        ----------
        fill_value : any
            The replacement value for null entries.

        Returns
        -------
        result : Array or ChunkedArray
            A new array with nulls replaced by the given value.

        Examples
        --------
        >>> import pyarrow as pa
        >>> fill_value = pa.scalar(5, type=pa.int8())
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.fill_null(fill_value)
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4,
            4,
            5,
            100
          ]
        ]
        """
        self._assert_cpu()
        return _pc().fill_null(self, fill_value)

    def equals(self, ChunkedArray other):
        """
        Return whether the contents of two chunked arrays are equal.

        Parameters
        ----------
        other : pyarrow.ChunkedArray
            Chunked array to compare against.

        Returns
        -------
        are_equal : bool

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> animals = pa.chunked_array((
        ...             ["Flamingo", "Parrot", "Dog"],
        ...             ["Horse", "Brittle stars", "Centipede"]
        ...             ))
        >>> n_legs.equals(n_legs)
        True
        >>> n_legs.equals(animals)
        False
        """
        self._assert_cpu()
        if other is None:
            return False

        cdef:
            CChunkedArray* this_arr = self.chunked_array
            CChunkedArray* other_arr = other.chunked_array
            c_bool result

        with nogil:
            result = this_arr.Equals(deref(other_arr))

        return result

    def _to_pandas(self, options, types_mapper=None, **kwargs):
        self._assert_cpu()
        return _array_like_to_pandas(self, options, types_mapper=types_mapper)

    def to_numpy(self, zero_copy_only=False):
        """
        Return a NumPy copy of this array (experimental).

        Parameters
        ----------
        zero_copy_only : bool, default False
            Introduced for signature consistence with pyarrow.Array.to_numpy.
            This must be False here since NumPy arrays' buffer must be contiguous.

        Returns
        -------
        array : numpy.ndarray

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs.to_numpy()
        array([  2,   2,   4,   4,   5, 100])
        """
        self._assert_cpu()
        if np is None:
            raise ImportError(
                "Cannot return a numpy.ndarray if NumPy is not present")
        if zero_copy_only:
            raise ValueError(
                "zero_copy_only must be False for pyarrow.ChunkedArray.to_numpy"
            )
        cdef:
            PyObject* out
            PandasOptions c_options
            object values

        c_options.to_numpy = True

        with nogil:
            check_status(
                ConvertChunkedArrayToPandas(
                    c_options,
                    self.sp_chunked_array,
                    self,
                    &out
                )
            )

        # wrap_array_output uses pandas to convert to Categorical, here
        # always convert to numpy array
        values = PyObject_to_object(out)

        if isinstance(values, dict):
            values = np.take(values['dictionary'], values['indices'])

        return values

    def __array__(self, dtype=None, copy=None):
        self._assert_cpu()
        if copy is False:
            raise ValueError(
                "Unable to avoid a copy while creating a numpy array as requested "
                "(converting a pyarrow.ChunkedArray always results in a copy).\n"
                "If using `np.array(obj, copy=False)` replace it with "
                "`np.asarray(obj)` to allow a copy when needed"
            )
        # 'copy' can further be ignored because to_numpy() already returns a copy
        values = self.to_numpy()
        if dtype is None:
            return values
        return values.astype(dtype, copy=False)

    def cast(self, object target_type=None, safe=None, options=None):
        """
        Cast array values to another data type

        See :func:`pyarrow.compute.cast` for usage.

        Parameters
        ----------
        target_type : DataType, None
            Type to cast array to.
        safe : boolean, default True
            Whether to check for conversion errors such as overflow.
        options : CastOptions, default None
            Additional checks pass by CastOptions

        Returns
        -------
        cast : Array or ChunkedArray

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs.type
        DataType(int64)

        Change the data type of an array:

        >>> n_legs_seconds = n_legs.cast(pa.duration('s'))
        >>> n_legs_seconds.type
        DurationType(duration[s])
        """
        self._assert_cpu()
        return _pc().cast(self, target_type, safe=safe, options=options)

    def dictionary_encode(self, null_encoding='mask'):
        """
        Compute dictionary-encoded representation of array.

        See :func:`pyarrow.compute.dictionary_encode` for full usage.

        Parameters
        ----------
        null_encoding : str, default "mask"
            How to handle null entries.

        Returns
        -------
        encoded : ChunkedArray
            A dictionary-encoded version of this array.

        Examples
        --------
        >>> import pyarrow as pa
        >>> animals = pa.chunked_array((
        ...             ["Flamingo", "Parrot", "Dog"],
        ...             ["Horse", "Brittle stars", "Centipede"]
        ...             ))
        >>> animals.dictionary_encode()
        <pyarrow.lib.ChunkedArray object at ...>
        [
        ...
          -- dictionary:
            [
              "Flamingo",
              "Parrot",
              "Dog",
              "Horse",
              "Brittle stars",
              "Centipede"
            ]
          -- indices:
            [
              0,
              1,
              2
            ],
        ...
          -- dictionary:
            [
              "Flamingo",
              "Parrot",
              "Dog",
              "Horse",
              "Brittle stars",
              "Centipede"
            ]
          -- indices:
            [
              3,
              4,
              5
            ]
        ]
        """
        self._assert_cpu()
        options = _pc().DictionaryEncodeOptions(null_encoding)
        return _pc().call_function('dictionary_encode', [self], options)

    def flatten(self, MemoryPool memory_pool=None):
        """
        Flatten this ChunkedArray.  If it has a struct type, the column is
        flattened into one array per struct field.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool

        Returns
        -------
        result : list of ChunkedArray

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> c_arr = pa.chunked_array(n_legs.value_counts())
        >>> c_arr
        <pyarrow.lib.ChunkedArray object at ...>
        [
          -- is_valid: all not null
          -- child 0 type: int64
            [
              2,
              4,
              5,
              100
            ]
          -- child 1 type: int64
            [
              2,
              2,
              1,
              1
            ]
        ]
        >>> c_arr.flatten()
        [<pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            4,
            5,
            100
          ]
        ], <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            1,
            1
          ]
        ]]
        >>> c_arr.type
        StructType(struct<values: int64, counts: int64>)
        >>> n_legs.type
        DataType(int64)
        """
        self._assert_cpu()
        cdef:
            vector[shared_ptr[CChunkedArray]] flattened
            CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)

        with nogil:
            flattened = GetResultValue(self.chunked_array.Flatten(pool))

        return [pyarrow_wrap_chunked_array(col) for col in flattened]

    def combine_chunks(self, MemoryPool memory_pool=None):
        """
        Flatten this ChunkedArray into a single non-chunked array.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool

        Returns
        -------
        result : Array

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.combine_chunks()
        <pyarrow.lib.Int64Array object at ...>
        [
          2,
          2,
          4,
          4,
          5,
          100
        ]
        """
        self._assert_cpu()
        if self.num_chunks == 0:
            return array([], type=self.type)
        else:
            return concat_arrays(self.chunks)

    def unique(self):
        """
        Compute distinct elements in array

        Returns
        -------
        pyarrow.Array

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.unique()
        <pyarrow.lib.Int64Array object at ...>
        [
          2,
          4,
          5,
          100
        ]
        """
        self._assert_cpu()
        return _pc().call_function('unique', [self])

    def value_counts(self):
        """
        Compute counts of unique elements in array.

        Returns
        -------
        An array of  <input type "Values", int64_t "Counts"> structs

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.value_counts()
        <pyarrow.lib.StructArray object at ...>
        -- is_valid: all not null
        -- child 0 type: int64
          [
            2,
            4,
            5,
            100
          ]
        -- child 1 type: int64
          [
            2,
            2,
            1,
            1
          ]
        """
        self._assert_cpu()
        return _pc().call_function('value_counts', [self])

    def slice(self, offset=0, length=None):
        """
        Compute zero-copy slice of this ChunkedArray

        Parameters
        ----------
        offset : int, default 0
            Offset from start of array to slice
        length : int, default None
            Length of slice (default is until end of batch starting from
            offset)

        Returns
        -------
        sliced : ChunkedArray

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.slice(2,2)
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            4
          ],
          [
            4
          ]
        ]
        """
        cdef shared_ptr[CChunkedArray] result

        if offset < 0:
            raise IndexError('Offset must be non-negative')

        offset = min(len(self), offset)
        if length is None:
            result = self.chunked_array.Slice(offset)
        else:
            result = self.chunked_array.Slice(offset, length)

        return pyarrow_wrap_chunked_array(result)

    def filter(self, mask, object null_selection_behavior="drop"):
        """
        Select values from the chunked array.

        See :func:`pyarrow.compute.filter` for full usage.

        Parameters
        ----------
        mask : Array or array-like
            The boolean mask to filter the chunked array with.
        null_selection_behavior : str, default "drop"
            How nulls in the mask should be handled.

        Returns
        -------
        filtered : Array or ChunkedArray
            An array of the same type, with only the elements selected by
            the boolean mask.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> mask = pa.array([True, False, None, True, False, True])
        >>> n_legs.filter(mask)
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2
          ],
          [
            4,
            100
          ]
        ]
        >>> n_legs.filter(mask, null_selection_behavior="emit_null")
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            null
          ],
          [
            4,
            100
          ]
        ]
        """
        self._assert_cpu()
        return _pc().filter(self, mask, null_selection_behavior)

    def index(self, value, start=None, end=None, *, memory_pool=None):
        """
        Find the first index of a value.

        See :func:`pyarrow.compute.index` for full usage.

        Parameters
        ----------
        value : Scalar or object
            The value to look for in the array.
        start : int, optional
            The start index where to look for `value`.
        end : int, optional
            The end index where to look for `value`.
        memory_pool : MemoryPool, optional
            A memory pool for potential memory allocations.

        Returns
        -------
        index : Int64Scalar
            The index of the value in the array (-1 if not found).

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.index(4)
        <pyarrow.Int64Scalar: 2>
        >>> n_legs.index(4, start=3)
        <pyarrow.Int64Scalar: 3>
        """
        self._assert_cpu()
        return _pc().index(self, value, start, end, memory_pool=memory_pool)

    def take(self, object indices):
        """
        Select values from the chunked array.

        See :func:`pyarrow.compute.take` for full usage.

        Parameters
        ----------
        indices : Array or array-like
            The indices in the array whose values will be returned.

        Returns
        -------
        taken : Array or ChunkedArray
            An array with the same datatype, containing the taken values.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            4
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.take([1,4,5])
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            5,
            100
          ]
        ]
        """
        self._assert_cpu()
        return _pc().take(self, indices)

    def drop_null(self):
        """
        Remove missing values from a chunked array.
        See :func:`pyarrow.compute.drop_null` for full description.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, None], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            null
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.drop_null()
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2
          ],
          [
            4,
            5,
            100
          ]
        ]
        """
        self._assert_cpu()
        return _pc().drop_null(self)

    def sort(self, order="ascending", **kwargs):
        """
        Sort the ChunkedArray

        Parameters
        ----------
        order : str, default "ascending"
            Which order to sort values in.
            Accepted values are "ascending", "descending".
        **kwargs : dict, optional
            Additional sorting options.
            As allowed by :class:`SortOptions`

        Returns
        -------
        result : ChunkedArray
        """
        self._assert_cpu()
        indices = _pc().sort_indices(
            self,
            options=_pc().SortOptions(sort_keys=[("", order)], **kwargs)
        )
        return self.take(indices)

    def unify_dictionaries(self, MemoryPool memory_pool=None):
        """
        Unify dictionaries across all chunks.

        This method returns an equivalent chunked array, but where all
        chunks share the same dictionary values.  Dictionary indices are
        transposed accordingly.

        If there are no dictionaries in the chunked array, it is returned
        unchanged.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool

        Returns
        -------
        result : ChunkedArray

        Examples
        --------
        >>> import pyarrow as pa
        >>> arr_1 = pa.array(["Flamingo", "Parrot", "Dog"]).dictionary_encode()
        >>> arr_2 = pa.array(["Horse", "Brittle stars", "Centipede"]).dictionary_encode()
        >>> c_arr = pa.chunked_array([arr_1, arr_2])
        >>> c_arr
        <pyarrow.lib.ChunkedArray object at ...>
        [
        ...
          -- dictionary:
            [
              "Flamingo",
              "Parrot",
              "Dog"
            ]
          -- indices:
            [
              0,
              1,
              2
            ],
        ...
          -- dictionary:
            [
              "Horse",
              "Brittle stars",
              "Centipede"
            ]
          -- indices:
            [
              0,
              1,
              2
            ]
        ]
        >>> c_arr.unify_dictionaries()
        <pyarrow.lib.ChunkedArray object at ...>
        [
        ...
          -- dictionary:
            [
              "Flamingo",
              "Parrot",
              "Dog",
              "Horse",
              "Brittle stars",
              "Centipede"
            ]
          -- indices:
            [
              0,
              1,
              2
            ],
        ...
          -- dictionary:
            [
              "Flamingo",
              "Parrot",
              "Dog",
              "Horse",
              "Brittle stars",
              "Centipede"
            ]
          -- indices:
            [
              3,
              4,
              5
            ]
        ]
        """
        self._assert_cpu()
        cdef:
            CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)
            shared_ptr[CChunkedArray] c_result

        with nogil:
            c_result = GetResultValue(CDictionaryUnifier.UnifyChunkedArray(
                self.sp_chunked_array, pool))

        return pyarrow_wrap_chunked_array(c_result)

    @property
    def num_chunks(self):
        """
        Number of underlying chunks.

        Returns
        -------
        int

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, None], [4, 5, 100]])
        >>> n_legs.num_chunks
        2
        """
        return self.chunked_array.num_chunks()

    def chunk(self, i):
        """
        Select a chunk by its index.

        Parameters
        ----------
        i : int

        Returns
        -------
        pyarrow.Array

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, None], [4, 5, 100]])
        >>> n_legs.chunk(1)
        <pyarrow.lib.Int64Array object at ...>
        [
          4,
          5,
          100
        ]
        """
        if i >= self.num_chunks or i < 0:
            raise IndexError('Chunk index out of range.')

        return pyarrow_wrap_array(self.chunked_array.chunk(i))

    @property
    def chunks(self):
        """
        Convert to a list of single-chunked arrays.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, None], [4, 5, 100]])
        >>> n_legs
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            2,
            null
          ],
          [
            4,
            5,
            100
          ]
        ]
        >>> n_legs.chunks
        [<pyarrow.lib.Int64Array object at ...>
        [
          2,
          2,
          null
        ], <pyarrow.lib.Int64Array object at ...>
        [
          4,
          5,
          100
        ]]
        """
        return list(self.iterchunks())

    def iterchunks(self):
        """
        Convert to an iterator of ChunkArrays.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> for i in n_legs.iterchunks():
        ...     print(i.null_count)
        ...
        0
        1

        """
        for i in range(self.num_chunks):
            yield self.chunk(i)

    def to_pylist(self, *, maps_as_pydicts=None):
        """
        Convert to a list of native Python objects.

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

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, None, 100]])
        >>> n_legs.to_pylist()
        [2, 2, 4, 4, None, 100]
        """
        self._assert_cpu()
        result = []
        for i in range(self.num_chunks):
            result += self.chunk(i).to_pylist(maps_as_pydicts=maps_as_pydicts)
        return result

    def __arrow_c_stream__(self, requested_schema=None):
        """
        Export to a C ArrowArrayStream PyCapsule.

        Parameters
        ----------
        requested_schema : PyCapsule, default None
            The schema to which the stream should be casted, passed as a
            PyCapsule containing a C ArrowSchema representation of the
            requested schema.

        Returns
        -------
        PyCapsule
            A capsule containing a C ArrowArrayStream struct.
        """
        self._assert_cpu()
        cdef:
            ChunkedArray chunked
            ArrowArrayStream* c_stream = NULL

        if requested_schema is not None:
            target_type = DataType._import_from_c_capsule(requested_schema)

            if target_type != self.type:
                try:
                    chunked = self.cast(target_type, safe=True)
                except ArrowInvalid as e:
                    raise ValueError(
                        f"Could not cast {self.type} to requested type {target_type}: {e}"
                    )
            else:
                chunked = self
        else:
            chunked = self

        stream_capsule = alloc_c_stream(&c_stream)

        with nogil:
            check_status(ExportChunkedArray(chunked.sp_chunked_array, c_stream))

        return stream_capsule

    @staticmethod
    def _import_from_c_capsule(stream):
        """
        Import ChunkedArray from a C ArrowArrayStream PyCapsule.

        Parameters
        ----------
        stream: PyCapsule
            A capsule containing a C ArrowArrayStream PyCapsule.

        Returns
        -------
        ChunkedArray
        """
        cdef:
            ArrowArrayStream* c_stream
            shared_ptr[CChunkedArray] c_chunked_array
            ChunkedArray self

        c_stream = <ArrowArrayStream*>PyCapsule_GetPointer(
            stream, 'arrow_array_stream'
        )

        with nogil:
            c_chunked_array = GetResultValue(ImportChunkedArray(c_stream))

        self = ChunkedArray.__new__(ChunkedArray)
        self.init(c_chunked_array)
        return self

    @property
    def is_cpu(self):
        """
        Whether all chunks in the ChunkedArray are CPU-accessible.
        """
        if not self._init_is_cpu:
            self._is_cpu = self.chunked_array.is_cpu()
            self._init_is_cpu = True
        return self._is_cpu

    def _assert_cpu(self):
        if not self.is_cpu:
            raise NotImplementedError("Implemented only for data on CPU device")


def chunked_array(arrays, type=None):
    """
    Construct chunked array from list of array-like objects

    Parameters
    ----------
    arrays : Array, list of Array, or array-like
        Must all be the same data type. Can be empty only if type also passed.
        Any Arrow-compatible array that implements the Arrow PyCapsule Protocol
        (has an ``__arrow_c_array__`` or ``__arrow_c_stream__`` method) can be
        passed as well.
    type : DataType or string coercible to DataType

    Returns
    -------
    ChunkedArray

    Examples
    --------
    >>> import pyarrow as pa
    >>> pa.chunked_array([], type=pa.int8())
    <pyarrow.lib.ChunkedArray object at ...>
    [
    ...
    ]

    >>> pa.chunked_array([[2, 2, 4], [4, 5, 100]])
    <pyarrow.lib.ChunkedArray object at ...>
    [
      [
        2,
        2,
        4
      ],
      [
        4,
        5,
        100
      ]
    ]
    """
    cdef:
        Array arr
        vector[shared_ptr[CArray]] c_arrays
        shared_ptr[CChunkedArray] c_result
        shared_ptr[CDataType] c_type

    type = ensure_type(type, allow_none=True)

    if isinstance(arrays, Array):
        arrays = [arrays]
    elif hasattr(arrays, "__arrow_c_stream__"):
        if type is not None:
            requested_type = type.__arrow_c_schema__()
        else:
            requested_type = None
        capsule = arrays.__arrow_c_stream__(requested_type)
        result = ChunkedArray._import_from_c_capsule(capsule)
        if type is not None and result.type != type:
            # __arrow_c_stream__ coerces schema with best effort, so we might
            # need to cast it if the producer wasn't able to cast to exact schema.
            result = result.cast(type)
        return result
    elif hasattr(arrays, "__arrow_c_array__"):
        arr = array(arrays, type=type)
        arrays = [arr]

    for x in arrays:
        arr = x if isinstance(x, Array) else array(x, type=type)

        if type is None:
            # it allows more flexible chunked array construction from to coerce
            # subsequent arrays to the firstly inferred array type
            # it also spares the inference overhead after the first chunk
            type = arr.type

        c_arrays.push_back(arr.sp_array)

    c_type = pyarrow_unwrap_data_type(type)
    with nogil:
        c_result = GetResultValue(CChunkedArray.Make(c_arrays, c_type))
    return pyarrow_wrap_chunked_array(c_result)


cdef _schema_from_arrays(arrays, names, metadata, shared_ptr[CSchema]* schema):
    cdef:
        Py_ssize_t K = len(arrays)
        c_string c_name
        shared_ptr[CDataType] c_type
        shared_ptr[const CKeyValueMetadata] c_meta
        vector[shared_ptr[CField]] c_fields

    if metadata is not None:
        c_meta = KeyValueMetadata(metadata).unwrap()

    if K == 0:
        if names is None or len(names) == 0:
            schema.reset(new CSchema(c_fields, c_meta))
            return arrays
        else:
            raise ValueError(f'Length of names ({len(names)}) does not match '
                             f'length of arrays ({K})')

    c_fields.resize(K)

    if names is None:
        raise ValueError('Must pass names or schema when constructing '
                         'Table or RecordBatch.')

    if len(names) != K:
        raise ValueError(f'Length of names ({len(names)}) does not match '
                         f'length of arrays ({K})')

    converted_arrays = []
    for i in range(K):
        val = arrays[i]
        if not isinstance(val, (Array, ChunkedArray)):
            val = array(val)

        c_type = (<DataType> val.type).sp_type

        if names[i] is None:
            c_name = b'None'
        else:
            c_name = tobytes(names[i])
        c_fields[i].reset(new CField(c_name, c_type, True))
        converted_arrays.append(val)

    schema.reset(new CSchema(c_fields, c_meta))
    return converted_arrays


cdef _sanitize_arrays(arrays, names, schema, metadata,
                      shared_ptr[CSchema]* c_schema):
    cdef Schema cy_schema
    if schema is None:
        converted_arrays = _schema_from_arrays(arrays, names, metadata,
                                               c_schema)
    else:
        if names is not None:
            raise ValueError('Cannot pass both schema and names')
        if metadata is not None:
            raise ValueError('Cannot pass both schema and metadata')
        cy_schema = schema

        if len(schema) != len(arrays):
            raise ValueError('Schema and number of arrays unequal')

        c_schema[0] = cy_schema.sp_schema
        converted_arrays = []
        for i, item in enumerate(arrays):
            item = asarray(item, type=schema[i].type)
            converted_arrays.append(item)
    return converted_arrays

cdef class _Tabular(_PandasConvertible):
    """Internal: An interface for common operations on tabular objects."""

    def __init__(self):
        raise TypeError(f"Do not call {self.__class__.__name__}'s constructor directly, use "
                        f"one of the `{self.__class__.__name__}.from_*` functions instead.")

    def __array__(self, dtype=None, copy=None):
        self._assert_cpu()
        if copy is False:
            raise ValueError(
                "Unable to avoid a copy while creating a numpy array as requested "
                f"(converting a pyarrow.{self.__class__.__name__} always results "
                "in a copy).\n"
                "If using `np.array(obj, copy=False)` replace it with "
                "`np.asarray(obj)` to allow a copy when needed"
            )
        # 'copy' can further be ignored because stacking will result in a copy
        column_arrays = [
            np.asarray(self.column(i), dtype=dtype) for i in range(self.num_columns)
        ]
        if column_arrays:
            arr = np.stack(column_arrays, axis=1)
        else:
            arr = np.empty((self.num_rows, 0), dtype=dtype)
        return arr

    def __dataframe__(self, nan_as_null: bool = False, allow_copy: bool = True):
        """
        Return the dataframe interchange object implementing the interchange protocol.

        Parameters
        ----------
        nan_as_null : bool, default False
            Whether to tell the DataFrame to overwrite null values in the data
            with ``NaN`` (or ``NaT``).
        allow_copy : bool, default True
            Whether to allow memory copying when exporting. If set to False
            it would cause non-zero-copy exports to fail.

        Returns
        -------
        DataFrame interchange object
            The object which consuming library can use to ingress the dataframe.

        Notes
        -----
        Details on the interchange protocol:
        https://data-apis.org/dataframe-protocol/latest/index.html
        `nan_as_null` currently has no effect; once support for nullable extension
        dtypes is added, this value should be propagated to columns.
        """

        from pyarrow.interchange.dataframe import _PyArrowDataFrame

        return _PyArrowDataFrame(self, nan_as_null, allow_copy)

    def __eq__(self, other):
        try:
            return self.equals(other)
        except TypeError:
            return NotImplemented

    def __getitem__(self, key):
        """
        Slice or return column at given index or column name

        Parameters
        ----------
        key : integer, str, or slice
            Slices with step not equal to 1 (or None) will produce a copy
            rather than a zero-copy view

        Returns
        -------
        Array (from RecordBatch) or ChunkedArray (from Table) for column input.
        RecordBatch or Table for slice input.
        """
        if isinstance(key, slice):
            return _normalize_slice(self, key)

        return self.column(key)

    def __len__(self):
        return self.num_rows

    def __repr__(self):
        if not self._is_initialized():
            raise ValueError("This object's internal pointer is NULL, do not "
                             "use any methods or attributes on this object")
        return self.to_string(preview_cols=10)

    def _column(self, int i):
        raise NotImplementedError

    def _ensure_integer_index(self, i):
        """
        Ensure integer index (convert string column name to integer if needed).
        """
        if isinstance(i, (bytes, str)):
            field_indices = self.schema.get_all_field_indices(i)

            if len(field_indices) == 0:
                raise KeyError(f'Field "{i}" does not exist in schema')
            elif len(field_indices) > 1:
                raise KeyError(
                    f'Field "{i}" exists {len(field_indices)} times in schema')
            else:
                return field_indices[0]
        elif isinstance(i, int):
            return i
        else:
            raise TypeError("Index must either be string or integer")

    def _is_initialized(self):
        raise NotImplementedError

    def column(self, i):
        """
        Select single column from Table or RecordBatch.

        Parameters
        ----------
        i : int or string
            The index or name of the column to retrieve.

        Returns
        -------
        column : Array (for RecordBatch) or ChunkedArray (for Table)

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Select a column by numeric index:

        >>> table.column(0)
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            2,
            4,
            5,
            100
          ]
        ]

        Select a column by its name:

        >>> table.column("animals")
        <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            "Flamingo",
            "Horse",
            "Brittle stars",
            "Centipede"
          ]
        ]
        """
        return self._column(self._ensure_integer_index(i))

    @property
    def column_names(self):
        """
        Names of the Table or RecordBatch columns.

        Returns
        -------
        list of str

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> table = pa.Table.from_arrays([[2, 4, 5, 100],
        ...                               ["Flamingo", "Horse", "Brittle stars", "Centipede"]],
        ...                               names=['n_legs', 'animals'])
        >>> table.column_names
        ['n_legs', 'animals']
        """
        return [self.field(i).name for i in range(self.num_columns)]

    @property
    def columns(self):
        """
        List of all columns in numerical order.

        Returns
        -------
        columns : list of Array (for RecordBatch) or list of ChunkedArray (for Table)

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [None, 4, 5, None],
        ...                    'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.columns
        [<pyarrow.lib.ChunkedArray object at ...>
        [
          [
            null,
            4,
            5,
            null
          ]
        ], <pyarrow.lib.ChunkedArray object at ...>
        [
          [
            "Flamingo",
            "Horse",
            null,
            "Centipede"
          ]
        ]]
        """
        return [self._column(i) for i in range(self.num_columns)]

    def drop_null(self):
        """
        Remove rows that contain missing values from a Table or RecordBatch.

        See :func:`pyarrow.compute.drop_null` for full usage.

        Returns
        -------
        Table or RecordBatch
            A tabular object with the same schema, with rows containing
            no missing values.

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'year': [None, 2022, 2019, 2021],
        ...                   'n_legs': [2, 4, 5, 100],
        ...                   'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.drop_null()
        pyarrow.Table
        year: double
        n_legs: int64
        animals: string
        ----
        year: [[2022,2021]]
        n_legs: [[4,100]]
        animals: [["Horse","Centipede"]]
        """
        self._assert_cpu()
        return _pc().drop_null(self)

    def field(self, i):
        """
        Select a schema field by its column name or numeric index.

        Parameters
        ----------
        i : int or string
            The index or name of the field to retrieve.

        Returns
        -------
        Field

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.field(0)
        pyarrow.Field<n_legs: int64>
        >>> table.field(1)
        pyarrow.Field<animals: string>
        """
        return self.schema.field(i)

    @classmethod
    def from_pydict(cls, mapping, schema=None, metadata=None):
        """
        Construct a Table or RecordBatch from Arrow arrays or columns.

        Parameters
        ----------
        mapping : dict or Mapping
            A mapping of strings to Arrays or Python lists.
        schema : Schema, default None
            If not passed, will be inferred from the Mapping values.
        metadata : dict or Mapping, default None
            Optional metadata for the schema (if inferred).

        Returns
        -------
        Table or RecordBatch

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
        >>> pydict = {'n_legs': n_legs, 'animals': animals}

        Construct a Table from a dictionary of arrays:

        >>> pa.Table.from_pydict(pydict)
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        >>> pa.Table.from_pydict(pydict).schema
        n_legs: int64
        animals: string

        Construct a Table from a dictionary of arrays with metadata:

        >>> my_metadata={"n_legs": "Number of legs per animal"}
        >>> pa.Table.from_pydict(pydict, metadata=my_metadata).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'

        Construct a Table from a dictionary of arrays with pyarrow schema:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64()),
        ...     pa.field('animals', pa.string())],
        ...     metadata={"n_legs": "Number of legs per animal"})
        >>> pa.Table.from_pydict(pydict, schema=my_schema).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'
        """

        return _from_pydict(cls=cls,
                            mapping=mapping,
                            schema=schema,
                            metadata=metadata)

    @classmethod
    def from_pylist(cls, mapping, schema=None, metadata=None):
        """
        Construct a Table or RecordBatch from list of rows / dictionaries.

        Parameters
        ----------
        mapping : list of dicts of rows
            A mapping of strings to row values.
        schema : Schema, default None
            If not passed, will be inferred from the first row of the
            mapping values.
        metadata : dict or Mapping, default None
            Optional metadata for the schema (if inferred).

        Returns
        -------
        Table or RecordBatch

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> pylist = [{'n_legs': 2, 'animals': 'Flamingo'},
        ...           {'n_legs': 4, 'animals': 'Dog'}]

        Construct a Table from a list of rows:

        >>> pa.Table.from_pylist(pylist)
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4]]
        animals: [["Flamingo","Dog"]]

        Construct a Table from a list of rows with metadata:

        >>> my_metadata={"n_legs": "Number of legs per animal"}
        >>> pa.Table.from_pylist(pylist, metadata=my_metadata).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'

        Construct a Table from a list of rows with pyarrow schema:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64()),
        ...     pa.field('animals', pa.string())],
        ...     metadata={"n_legs": "Number of legs per animal"})
        >>> pa.Table.from_pylist(pylist, schema=my_schema).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'
        """

        return _from_pylist(cls=cls,
                            mapping=mapping,
                            schema=schema,
                            metadata=metadata)

    def itercolumns(self):
        """
        Iterator over all columns in their numerical order.

        Yields
        ------
        Array (for RecordBatch) or ChunkedArray (for Table)

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [None, 4, 5, None],
        ...                    'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> for i in table.itercolumns():
        ...     print(i.null_count)
        ...
        2
        1
        """
        for i in range(self.num_columns):
            yield self._column(i)

    @property
    def num_columns(self):
        raise NotImplementedError

    @property
    def num_rows(self):
        raise NotImplementedError

    @property
    def shape(self):
        """
        Dimensions of the table or record batch: (#rows, #columns).

        Returns
        -------
        (int, int)
            Number of rows and number of columns.

        Examples
        --------
        >>> import pyarrow as pa
        >>> table = pa.table({'n_legs': [None, 4, 5, None],
        ...                   'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table.shape
        (4, 2)
        """
        return (self.num_rows, self.num_columns)

    @property
    def schema(self):
        raise NotImplementedError

    def sort_by(self, sorting, **kwargs):
        """
        Sort the Table or RecordBatch by one or multiple columns.

        Parameters
        ----------
        sorting : str or list[tuple(name, order)]
            Name of the column to use to sort (ascending), or
            a list of multiple sorting conditions where
            each entry is a tuple with column name
            and sorting order ("ascending" or "descending")
        **kwargs : dict, optional
            Additional sorting options.
            As allowed by :class:`SortOptions`

        Returns
        -------
        Table or RecordBatch
            A new tabular object sorted according to the sort keys.

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pandas as pd
        >>> import pyarrow as pa
        >>> df = pd.DataFrame({'year': [2020, 2022, 2021, 2022, 2019, 2021],
        ...                    'n_legs': [2, 2, 4, 4, 5, 100],
        ...                    'animal': ["Flamingo", "Parrot", "Dog", "Horse",
        ...                    "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.sort_by('animal')
        pyarrow.Table
        year: int64
        n_legs: int64
        animal: string
        ----
        year: [[2019,2021,2021,2020,2022,2022]]
        n_legs: [[5,100,4,2,4,2]]
        animal: [["Brittle stars","Centipede","Dog","Flamingo","Horse","Parrot"]]
        """
        self._assert_cpu()
        if isinstance(sorting, str):
            sorting = [(sorting, "ascending")]

        indices = _pc().sort_indices(
            self,
            options=_pc().SortOptions(sort_keys=sorting, **kwargs)
        )
        return self.take(indices)

    def take(self, object indices):
        """
        Select rows from a Table or RecordBatch.

        See :func:`pyarrow.compute.take` for full usage.

        Parameters
        ----------
        indices : Array or array-like
            The indices in the tabular object whose rows will be returned.

        Returns
        -------
        Table or RecordBatch
            A tabular object with the same schema, containing the taken rows.

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'year': [2020, 2022, 2019, 2021],
        ...                    'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.take([1,3])
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2022,2021]]
        n_legs: [[4,100]]
        animals: [["Horse","Centipede"]]
        """
        self._assert_cpu()
        return _pc().take(self, indices)

    def filter(self, mask, object null_selection_behavior="drop"):
        """
        Select rows from the table or record batch based on a boolean mask.

        The Table can be filtered based on a mask, which will be passed to
        :func:`pyarrow.compute.filter` to perform the filtering, or it can
        be filtered through a boolean :class:`.Expression`

        Parameters
        ----------
        mask : Array or array-like or .Expression
            The boolean mask or the :class:`.Expression` to filter the table with.
        null_selection_behavior : str, default "drop"
            How nulls in the mask should be handled, does nothing if
            an :class:`.Expression` is used.

        Returns
        -------
        filtered : Table or RecordBatch
            A tabular object of the same schema, with only the rows selected
            by applied filtering

        Examples
        --------
        Using a Table (works similarly for RecordBatch):

        >>> import pyarrow as pa
        >>> table = pa.table({'year': [2020, 2022, 2019, 2021],
        ...                   'n_legs': [2, 4, 5, 100],
        ...                   'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})

        Define an expression and select rows:

        >>> import pyarrow.compute as pc
        >>> expr = pc.field("year") <= 2020
        >>> table.filter(expr)
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2020,2019]]
        n_legs: [[2,5]]
        animals: [["Flamingo","Brittle stars"]]

        Define a mask and select rows:

        >>> mask=[True, True, False, None]
        >>> table.filter(mask)
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2020,2022]]
        n_legs: [[2,4]]
        animals: [["Flamingo","Horse"]]
        >>> table.filter(mask, null_selection_behavior='emit_null')
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2020,2022,null]]
        n_legs: [[2,4,null]]
        animals: [["Flamingo","Horse",null]]
        """
        self._assert_cpu()
        if isinstance(mask, _pc().Expression):
            return _pac()._filter_table(self, mask)
        else:
            return _pc().filter(self, mask, null_selection_behavior)

    def to_pydict(self, *, maps_as_pydicts=None):
        """
        Convert the Table or RecordBatch to a dict or OrderedDict.

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

        Returns
        -------
        dict

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> table = pa.Table.from_arrays([n_legs, animals], names=["n_legs", "animals"])
        >>> table.to_pydict()
        {'n_legs': [2, 2, 4, 4, 5, 100], 'animals': ['Flamingo', 'Parrot', ..., 'Centipede']}
        """
        entries = []
        for i in range(self.num_columns):
            name = self.field(i).name
            column = self[i].to_pylist(maps_as_pydicts=maps_as_pydicts)
            entries.append((name, column))
        return ordered_dict(entries)

    def to_pylist(self, *, maps_as_pydicts=None):
        """
        Convert the Table or RecordBatch to a list of rows / dictionaries.

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

        Returns
        -------
        list

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> data = [[2, 4, 5, 100],
        ...         ["Flamingo", "Horse", "Brittle stars", "Centipede"]]
        >>> table = pa.table(data, names=["n_legs", "animals"])
        >>> table.to_pylist()
        [{'n_legs': 2, 'animals': 'Flamingo'}, {'n_legs': 4, 'animals': 'Horse'}, ...
        """
        pydict = self.to_pydict(maps_as_pydicts=maps_as_pydicts)
        names = self.schema.names
        pylist = [{column: pydict[column][row] for column in names}
                  for row in range(self.num_rows)]
        return pylist

    def to_string(self, *, show_metadata=False, preview_cols=0):
        """
        Return human-readable string representation of Table or RecordBatch.

        Parameters
        ----------
        show_metadata : bool, default False
            Display Field-level and Schema-level KeyValueMetadata.
        preview_cols : int, default 0
            Display values of the columns for the first N columns.

        Returns
        -------
        str
        """
        # Use less verbose schema output.
        schema_as_string = self.schema.to_string(
            show_field_metadata=show_metadata,
            show_schema_metadata=show_metadata
        )
        title = f'pyarrow.{type(self).__name__}\n{schema_as_string}'
        pieces = [title]
        if preview_cols:
            pieces.append('----')
            for i in range(min(self.num_columns, preview_cols)):
                pieces.append(
                    f'{self.field(i).name}: {self.column(i).to_string(indent=0, skip_new_lines=True)}')
            if preview_cols < self.num_columns:
                pieces.append('...')
        return '\n'.join(pieces)

    def remove_column(self, int i):
        # implemented in RecordBatch/Table subclasses
        raise NotImplementedError

    def drop_columns(self, columns):
        """
        Drop one or more columns and return a new Table or RecordBatch.

        Parameters
        ----------
        columns : str or list[str]
            Field name(s) referencing existing column(s).

        Raises
        ------
        KeyError
            If any of the passed column names do not exist.

        Returns
        -------
        Table or RecordBatch
            A tabular object without the column(s).

        Examples
        --------
        Table (works similarly for RecordBatch)

        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Drop one column:

        >>> table.drop_columns("animals")
        pyarrow.Table
        n_legs: int64
        ----
        n_legs: [[2,4,5,100]]

        Drop one or more columns:

        >>> table.drop_columns(["n_legs", "animals"])
        pyarrow.Table
        ...
        ----
        """
        if isinstance(columns, str):
            columns = [columns]

        indices = []
        for col in columns:
            idx = self.schema.get_field_index(col)
            if idx == -1:
                raise KeyError(f"Column {col!r} not found")
            indices.append(idx)

        indices.sort()
        indices.reverse()

        res = self
        for idx in indices:
            res = res.remove_column(idx)

        return res

    def add_column(self, int i, field_, column):
        # implemented in RecordBatch/Table subclasses
        raise NotImplementedError

    def append_column(self, field_, column):
        """
        Append column at end of columns.

        Parameters
        ----------
        field_ : str or Field
            If a string is passed then the type is deduced from the column
            data.
        column : Array or value coercible to array
            Column data.

        Returns
        -------
        Table or RecordBatch
            New table or record batch with the passed column added.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Append column at the end:

        >>> year = [2021, 2022, 2019, 2021]
        >>> table.append_column('year', [year])
        pyarrow.Table
        n_legs: int64
        animals: string
        year: int64
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        year: [[2021,2022,2019,2021]]
        """
        return self.add_column(self.num_columns, field_, column)

    cdef void _assert_cpu(self) except *:
        return


cdef class RecordBatch(_Tabular):
    """
    Batch of rows of columns of equal length

    Warnings
    --------
    Do not call this class's constructor directly, use one of the
    ``RecordBatch.from_*`` functions instead.

    Examples
    --------
    >>> import pyarrow as pa
    >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
    >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
    >>> names = ["n_legs", "animals"]

    Constructing a RecordBatch from arrays:

    >>> pa.RecordBatch.from_arrays([n_legs, animals], names=names)
    pyarrow.RecordBatch
    n_legs: int64
    animals: string
    ----
    n_legs: [2,2,4,4,5,100]
    animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]
    >>> pa.RecordBatch.from_arrays([n_legs, animals], names=names).to_pandas()
       n_legs        animals
    0       2       Flamingo
    1       2         Parrot
    2       4            Dog
    3       4          Horse
    4       5  Brittle stars
    5     100      Centipede

    Constructing a RecordBatch from pandas DataFrame:

    >>> import pandas as pd
    >>> df = pd.DataFrame({'year': [2020, 2022, 2021, 2022],
    ...                    'month': [3, 5, 7, 9],
    ...                    'day': [1, 5, 9, 13],
    ...                    'n_legs': [2, 4, 5, 100],
    ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
    >>> pa.RecordBatch.from_pandas(df)
    pyarrow.RecordBatch
    year: int64
    month: int64
    day: int64
    n_legs: int64
    animals: string
    ----
    year: [2020,2022,2021,2022]
    month: [3,5,7,9]
    day: [1,5,9,13]
    n_legs: [2,4,5,100]
    animals: ["Flamingo","Horse","Brittle stars","Centipede"]
    >>> pa.RecordBatch.from_pandas(df).to_pandas()
       year  month  day  n_legs        animals
    0  2020      3    1       2       Flamingo
    1  2022      5    5       4          Horse
    2  2021      7    9       5  Brittle stars
    3  2022      9   13     100      Centipede

    Constructing a RecordBatch from pylist:

    >>> pylist = [{'n_legs': 2, 'animals': 'Flamingo'},
    ...           {'n_legs': 4, 'animals': 'Dog'}]
    >>> pa.RecordBatch.from_pylist(pylist).to_pandas()
       n_legs   animals
    0       2  Flamingo
    1       4       Dog

    You can also construct a RecordBatch using :func:`pyarrow.record_batch`:

    >>> pa.record_batch([n_legs, animals], names=names).to_pandas()
       n_legs        animals
    0       2       Flamingo
    1       2         Parrot
    2       4            Dog
    3       4          Horse
    4       5  Brittle stars
    5     100      Centipede

    >>> pa.record_batch(df)
    pyarrow.RecordBatch
    year: int64
    month: int64
    day: int64
    n_legs: int64
    animals: string
    ----
    year: [2020,2022,2021,2022]
    month: [3,5,7,9]
    day: [1,5,9,13]
    n_legs: [2,4,5,100]
    animals: ["Flamingo","Horse","Brittle stars","Centipede"]
    """

    def __cinit__(self):
        self.batch = NULL
        self._schema = None

    cdef void init(self, const shared_ptr[CRecordBatch]& batch):
        self.sp_batch = batch
        self.batch = batch.get()

    def _is_initialized(self):
        return self.batch != NULL

    def __reduce__(self):
        self._assert_cpu()
        return _reconstruct_record_batch, (self.columns, self.schema)

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
            self._assert_cpu()
            with nogil:
                check_status(self.batch.ValidateFull())
        else:
            with nogil:
                check_status(self.batch.Validate())

    def replace_schema_metadata(self, metadata=None):
        """
        Create shallow copy of record batch by replacing schema
        key-value metadata with the indicated new metadata (which may be None,
        which deletes any existing metadata

        Parameters
        ----------
        metadata : dict, default None

        Returns
        -------
        shallow_copy : RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])

        Constructing a RecordBatch with schema and metadata:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64())],
        ...     metadata={"n_legs": "Number of legs per animal"})
        >>> batch = pa.RecordBatch.from_arrays([n_legs], schema=my_schema)
        >>> batch.schema
        n_legs: int64
        -- schema metadata --
        n_legs: 'Number of legs per animal'

        Shallow copy of a RecordBatch with deleted schema metadata:

        >>> batch.replace_schema_metadata().schema
        n_legs: int64
        """
        cdef:
            shared_ptr[const CKeyValueMetadata] c_meta
            shared_ptr[CRecordBatch] c_batch

        metadata = ensure_metadata(metadata, allow_none=True)
        c_meta = pyarrow_unwrap_metadata(metadata)
        with nogil:
            c_batch = self.batch.ReplaceSchemaMetadata(c_meta)

        return pyarrow_wrap_batch(c_batch)

    @property
    def num_columns(self):
        """
        Number of columns

        Returns
        -------
        int

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch.num_columns
        2
        """
        return self.batch.num_columns()

    @property
    def num_rows(self):
        """
        Number of rows

        Due to the definition of a RecordBatch, all columns have the same
        number of rows.

        Returns
        -------
        int

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch.num_rows
        6
        """
        return self.batch.num_rows()

    @property
    def schema(self):
        """
        Schema of the RecordBatch and its columns

        Returns
        -------
        pyarrow.Schema

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch.schema
        n_legs: int64
        animals: string
        """
        if self._schema is None:
            self._schema = pyarrow_wrap_schema(self.batch.schema())

        return self._schema

    def _column(self, int i):
        """
        Select single column from record batch by its numeric index.

        Parameters
        ----------
        i : int
            The index of the column to retrieve.

        Returns
        -------
        column : pyarrow.Array
        """
        cdef int index = <int> _normalize_index(i, self.num_columns)
        cdef Array result = pyarrow_wrap_array(self.batch.column(index))
        result._name = self.schema[index].name
        return result

    @property
    def nbytes(self):
        """
        Total number of bytes consumed by the elements of the record batch.

        In other words, the sum of bytes from all buffer ranges referenced.

        Unlike `get_total_buffer_size` this method will account for array
        offsets.

        If buffers are shared between arrays then the shared
        portion will only be counted multiple times.

        The dictionary of dictionary arrays will always be counted in their
        entirety even if the array only references a portion of the dictionary.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch.nbytes
        116
        """
        self._assert_cpu()
        cdef:
            CResult[int64_t] c_res_buffer

        with nogil:
            c_res_buffer = ReferencedBufferSize(deref(self.batch))
            size = GetResultValue(c_res_buffer)
        return size

    def get_total_buffer_size(self):
        """
        The sum of bytes in each buffer referenced by the record batch

        An array may only reference a portion of a buffer.
        This method will overestimate in this case and return the
        byte size of the entire buffer.

        If a buffer is referenced multiple times then it will
        only be counted once.

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch.get_total_buffer_size()
        120
        """
        self._assert_cpu()
        cdef:
            int64_t total_buffer_size

        total_buffer_size = TotalBufferSize(deref(self.batch))
        return total_buffer_size

    def __sizeof__(self):
        return super(RecordBatch, self).__sizeof__() + self.nbytes

    def add_column(self, int i, field_, column):
        """
        Add column to RecordBatch at position i.

        A new record batch is returned with the column added, the original record batch
        object is left unchanged.

        Parameters
        ----------
        i : int
            Index to place the column at.
        field_ : str or Field
            If a string is passed then the type is deduced from the column
            data.
        column : Array or value coercible to array
            Column data.

        Returns
        -------
        RecordBatch
            New record batch with the passed column added.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> batch = pa.RecordBatch.from_pandas(df)

        Add column:

        >>> year = [2021, 2022, 2019, 2021]
        >>> batch.add_column(0,"year", year)
        pyarrow.RecordBatch
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [2021,2022,2019,2021]
        n_legs: [2,4,5,100]
        animals: ["Flamingo","Horse","Brittle stars","Centipede"]

        Original record batch is left unchanged:

        >>> batch
        pyarrow.RecordBatch
        n_legs: int64
        animals: string
        ----
        n_legs: [2,4,5,100]
        animals: ["Flamingo","Horse","Brittle stars","Centipede"]
        """
        cdef:
            shared_ptr[CRecordBatch] c_batch
            Field c_field
            Array c_arr
            CDeviceAllocationType device_type = self.sp_batch.get().device_type()

        if isinstance(column, Array):
            c_arr = column
        else:
            c_arr = array(column)

        if device_type != c_arr.sp_array.get().device_type():
            raise TypeError("The column must be allocated on the same "
                            "device as the RecordBatch. Got column on "
                            f"device {c_arr.device_type!r}, but expected "
                            f"{self.device_type!r}.")

        if isinstance(field_, Field):
            c_field = field_
        else:
            c_field = field(field_, c_arr.type)

        with nogil:
            c_batch = GetResultValue(self.batch.AddColumn(
                i, c_field.sp_field, c_arr.sp_array))

        return pyarrow_wrap_batch(c_batch)

    def remove_column(self, int i):
        """
        Create new RecordBatch with the indicated column removed.

        Parameters
        ----------
        i : int
            Index of column to remove.

        Returns
        -------
        Table
            New record batch without the column.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> batch = pa.RecordBatch.from_pandas(df)
        >>> batch.remove_column(1)
        pyarrow.RecordBatch
        n_legs: int64
        ----
        n_legs: [2,4,5,100]
        """
        cdef shared_ptr[CRecordBatch] c_batch

        with nogil:
            c_batch = GetResultValue(self.batch.RemoveColumn(i))

        return pyarrow_wrap_batch(c_batch)

    def set_column(self, int i, field_, column):
        """
        Replace column in RecordBatch at position.

        Parameters
        ----------
        i : int
            Index to place the column at.
        field_ : str or Field
            If a string is passed then the type is deduced from the column
            data.
        column : Array or value coercible to array
            Column data.

        Returns
        -------
        RecordBatch
            New record batch with the passed column set.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> batch = pa.RecordBatch.from_pandas(df)

        Replace a column:

        >>> year = [2021, 2022, 2019, 2021]
        >>> batch.set_column(1,'year', year)
        pyarrow.RecordBatch
        n_legs: int64
        year: int64
        ----
        n_legs: [2,4,5,100]
        year: [2021,2022,2019,2021]
        """
        cdef:
            shared_ptr[CRecordBatch] c_batch
            Field c_field
            Array c_arr
            CDeviceAllocationType device_type = self.sp_batch.get().device_type()

        if isinstance(column, Array):
            c_arr = column
        else:
            c_arr = array(column)

        if device_type != c_arr.sp_array.get().device_type():
            raise TypeError("The column must be allocated on the same "
                            "device as the RecordBatch. Got column on "
                            f"device {c_arr.device_type!r}, but expected "
                            f"{self.device_type!r}.")

        if isinstance(field_, Field):
            c_field = field_
        else:
            c_field = field(field_, c_arr.type)

        with nogil:
            c_batch = GetResultValue(self.batch.SetColumn(
                i, c_field.sp_field, c_arr.sp_array))

        return pyarrow_wrap_batch(c_batch)

    def rename_columns(self, names):
        """
        Create new record batch with columns renamed to provided names.

        Parameters
        ----------
        names : list[str] or dict[str, str]
            List of new column names or mapping of old column names to new column names.

            If a mapping of old to new column names is passed, then all columns which are
            found to match a provided old column name will be renamed to the new column name.
            If any column names are not found in the mapping, a KeyError will be raised.

        Raises
        ------
        KeyError
            If any of the column names passed in the names mapping do not exist.

        Returns
        -------
        RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> batch = pa.RecordBatch.from_pandas(df)
        >>> new_names = ["n", "name"]
        >>> batch.rename_columns(new_names)
        pyarrow.RecordBatch
        n: int64
        name: string
        ----
        n: [2,4,5,100]
        name: ["Flamingo","Horse","Brittle stars","Centipede"]
        >>> new_names = {"n_legs": "n", "animals": "name"}
        >>> batch.rename_columns(new_names)
        pyarrow.RecordBatch
        n: int64
        name: string
        ----
        n: [2,4,5,100]
        name: ["Flamingo","Horse","Brittle stars","Centipede"]
        """
        cdef:
            shared_ptr[CRecordBatch] c_batch
            vector[c_string] c_names

        if isinstance(names, (list, tuple)):
            for name in names:
                c_names.push_back(tobytes(name))
        elif isinstance(names, dict):
            idx_to_new_name = {}
            for name, new_name in names.items():
                indices = self.schema.get_all_field_indices(name)

                if not indices:
                    raise KeyError(f"Column {name!r} not found")

                for index in indices:
                    idx_to_new_name[index] = new_name

            for i in range(self.num_columns):
                new_name = idx_to_new_name.get(i, self.column_names[i])
                c_names.push_back(tobytes(new_name))
        else:
            raise TypeError(f"names must be a list or dict not {type(names)!r}")

        with nogil:
            c_batch = GetResultValue(self.batch.RenameColumns(move(c_names)))

        return pyarrow_wrap_batch(c_batch)

    def serialize(self, memory_pool=None):
        """
        Write RecordBatch to Buffer as encapsulated IPC message, which does not
        include a Schema.

        To reconstruct a RecordBatch from the encapsulated IPC message Buffer
        returned by this function, a Schema must be passed separately. See
        Examples.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            Uses default memory pool if not specified

        Returns
        -------
        serialized : Buffer

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> buf = batch.serialize()
        >>> buf
        <pyarrow.Buffer address=0x... size=... is_cpu=True is_mutable=True>

        Reconstruct RecordBatch from IPC message Buffer and original Schema

        >>> pa.ipc.read_record_batch(buf, batch.schema)
        pyarrow.RecordBatch
        n_legs: int64
        animals: string
        ----
        n_legs: [2,2,4,4,5,100]
        animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]
        """
        self._assert_cpu()
        cdef shared_ptr[CBuffer] buffer
        cdef CIpcWriteOptions options = CIpcWriteOptions.Defaults()
        options.memory_pool = maybe_unbox_memory_pool(memory_pool)

        with nogil:
            buffer = GetResultValue(
                SerializeRecordBatch(deref(self.batch), options))
        return pyarrow_wrap_buffer(buffer)

    def slice(self, offset=0, length=None):
        """
        Compute zero-copy slice of this RecordBatch

        Parameters
        ----------
        offset : int, default 0
            Offset from start of record batch to slice
        length : int, default None
            Length of slice (default is until end of batch starting from
            offset)

        Returns
        -------
        sliced : RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch.to_pandas()
           n_legs        animals
        0       2       Flamingo
        1       2         Parrot
        2       4            Dog
        3       4          Horse
        4       5  Brittle stars
        5     100      Centipede
        >>> batch.slice(offset=3).to_pandas()
           n_legs        animals
        0       4          Horse
        1       5  Brittle stars
        2     100      Centipede
        >>> batch.slice(length=2).to_pandas()
           n_legs   animals
        0       2  Flamingo
        1       2    Parrot
        >>> batch.slice(offset=3, length=1).to_pandas()
           n_legs animals
        0       4   Horse
        """
        cdef shared_ptr[CRecordBatch] result

        if offset < 0:
            raise IndexError('Offset must be non-negative')

        offset = min(len(self), offset)
        if length is None:
            result = self.batch.Slice(offset)
        else:
            result = self.batch.Slice(offset, length)

        return pyarrow_wrap_batch(result)

    def equals(self, object other, bint check_metadata=False):
        """
        Check if contents of two record batches are equal.

        Parameters
        ----------
        other : pyarrow.RecordBatch
            RecordBatch to compare against.
        check_metadata : bool, default False
            Whether schema metadata equality should be checked as well.

        Returns
        -------
        are_equal : bool

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                     names=["n_legs", "animals"])
        >>> batch_0 = pa.record_batch([])
        >>> batch_1 = pa.RecordBatch.from_arrays([n_legs, animals],
        ...                                       names=["n_legs", "animals"],
        ...                                       metadata={"n_legs": "Number of legs per animal"})
        >>> batch.equals(batch)
        True
        >>> batch.equals(batch_0)
        False
        >>> batch.equals(batch_1)
        True
        >>> batch.equals(batch_1, check_metadata=True)
        False
        """
        self._assert_cpu()
        cdef:
            CRecordBatch* this_batch = self.batch
            shared_ptr[CRecordBatch] other_batch = pyarrow_unwrap_batch(other)
            c_bool result

        if not other_batch:
            return False

        with nogil:
            result = this_batch.Equals(deref(other_batch), check_metadata)

        return result

    def select(self, object columns):
        """
        Select columns of the RecordBatch.

        Returns a new RecordBatch with the specified columns, and metadata
        preserved.

        Parameters
        ----------
        columns : list-like
            The column names or integer indices to select.

        Returns
        -------
        RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> batch = pa.record_batch([n_legs, animals],
        ...                          names=["n_legs", "animals"])

        Select columns my indices:

        >>> batch.select([1])
        pyarrow.RecordBatch
        animals: string
        ----
        animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]

        Select columns by names:

        >>> batch.select(["n_legs"])
        pyarrow.RecordBatch
        n_legs: int64
        ----
        n_legs: [2,2,4,4,5,100]
        """
        cdef:
            shared_ptr[CRecordBatch] c_batch
            vector[int] c_indices

        for idx in columns:
            idx = self._ensure_integer_index(idx)
            idx = _normalize_index(idx, self.num_columns)
            c_indices.push_back(<int> idx)

        with nogil:
            c_batch = GetResultValue(self.batch.SelectColumns(move(c_indices)))

        return pyarrow_wrap_batch(c_batch)

    def cast(self, Schema target_schema, safe=None, options=None):
        """
        Cast record batch values to another schema.

        Parameters
        ----------
        target_schema : Schema
            Schema to cast to, the names and order of fields must match.
        safe : bool, default True
            Check for overflows or other unsafe conversions.
        options : CastOptions, default None
            Additional checks pass by CastOptions

        Returns
        -------
        RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> batch = pa.RecordBatch.from_pandas(df)
        >>> batch.schema
        n_legs: int64
        animals: string
        -- schema metadata --
        pandas: '{"index_columns": [{"kind": "range", "name": null, "start": 0, ...

        Define new schema and cast batch values:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.duration('s')),
        ...     pa.field('animals', pa.string())]
        ...     )
        >>> batch.cast(target_schema=my_schema)
        pyarrow.RecordBatch
        n_legs: duration[s]
        animals: string
        ----
        n_legs: [2,4,5,100]
        animals: ["Flamingo","Horse","Brittle stars","Centipede"]
        """
        cdef:
            Array column, casted
            Field field
            list newcols = []

        if self.schema.names != target_schema.names:
            raise ValueError(f"Target schema's field names are not matching "
                             f"the record batch's field names: {self.schema.names!r}, {target_schema.names!r}")

        for column, field in zip(self.itercolumns(), target_schema):
            if not field.nullable and column.null_count > 0:
                raise ValueError(
                    f"Casting field {field.name!r} with null values to non-nullable")
            casted = column.cast(field.type, safe=safe, options=options)
            newcols.append(casted)

        return RecordBatch.from_arrays(newcols, schema=target_schema)

    def _to_pandas(self, options, **kwargs):
        self._assert_cpu()
        return Table.from_batches([self])._to_pandas(options, **kwargs)

    @classmethod
    def from_pandas(cls, df, Schema schema=None, preserve_index=None,
                    nthreads=None, columns=None):
        """
        Convert pandas.DataFrame to an Arrow RecordBatch

        Parameters
        ----------
        df : pandas.DataFrame
        schema : pyarrow.Schema, optional
            The expected schema of the RecordBatch. This can be used to
            indicate the type of columns if we cannot infer it automatically.
            If passed, the output will have exactly this schema. Columns
            specified in the schema that are not found in the DataFrame columns
            or its index will raise an error. Additional columns or index
            levels in the DataFrame which are not specified in the schema will
            be ignored.
        preserve_index : bool, optional
            Whether to store the index as an additional column in the resulting
            ``RecordBatch``. The default of None will store the index as a
            column, except for RangeIndex which is stored as metadata only. Use
            ``preserve_index=True`` to force it to be stored as a column.
        nthreads : int, default None
            If greater than 1, convert columns to Arrow in parallel using
            indicated number of threads. By default, this follows
            :func:`pyarrow.cpu_count` (may use up to system CPU count threads).
        columns : list, optional
           List of column to be converted. If None, use all columns.

        Returns
        -------
        pyarrow.RecordBatch


        Examples
        --------
        >>> import pandas as pd
        >>> df = pd.DataFrame({'year': [2020, 2022, 2021, 2022],
        ...                    'month': [3, 5, 7, 9],
        ...                    'day': [1, 5, 9, 13],
        ...                    'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})

        Convert pandas DataFrame to RecordBatch:

        >>> import pyarrow as pa
        >>> pa.RecordBatch.from_pandas(df)
        pyarrow.RecordBatch
        year: int64
        month: int64
        day: int64
        n_legs: int64
        animals: string
        ----
        year: [2020,2022,2021,2022]
        month: [3,5,7,9]
        day: [1,5,9,13]
        n_legs: [2,4,5,100]
        animals: ["Flamingo","Horse","Brittle stars","Centipede"]

        Convert pandas DataFrame to RecordBatch using schema:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64()),
        ...     pa.field('animals', pa.string())],
        ...     metadata={"n_legs": "Number of legs per animal"})
        >>> pa.RecordBatch.from_pandas(df, schema=my_schema)
        pyarrow.RecordBatch
        n_legs: int64
        animals: string
        ----
        n_legs: [2,4,5,100]
        animals: ["Flamingo","Horse","Brittle stars","Centipede"]

        Convert pandas DataFrame to RecordBatch specifying columns:

        >>> pa.RecordBatch.from_pandas(df, columns=["n_legs"])
        pyarrow.RecordBatch
        n_legs: int64
        ----
        n_legs: [2,4,5,100]
        """
        from pyarrow.pandas_compat import dataframe_to_arrays
        arrays, schema, n_rows = dataframe_to_arrays(
            df, schema, preserve_index, nthreads=nthreads, columns=columns
        )

        # If df is empty but row index is not, create empty RecordBatch with rows >0
        cdef vector[shared_ptr[CArray]] c_arrays
        if n_rows:
            return pyarrow_wrap_batch(CRecordBatch.Make((<Schema> schema).sp_schema,
                                                        n_rows, c_arrays))
        else:
            return cls.from_arrays(arrays, schema=schema)

    @staticmethod
    def from_arrays(list arrays, names=None, schema=None, metadata=None):
        """
        Construct a RecordBatch from multiple pyarrow.Arrays

        Parameters
        ----------
        arrays : list of pyarrow.Array
            One for each field in RecordBatch
        names : list of str, optional
            Names for the batch fields. If not passed, schema must be passed
        schema : Schema, default None
            Schema for the created batch. If not passed, names must be passed
        metadata : dict or Mapping, default None
            Optional metadata for the schema (if inferred).

        Returns
        -------
        pyarrow.RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> names = ["n_legs", "animals"]

        Construct a RecordBatch from pyarrow Arrays using names:

        >>> pa.RecordBatch.from_arrays([n_legs, animals], names=names)
        pyarrow.RecordBatch
        n_legs: int64
        animals: string
        ----
        n_legs: [2,2,4,4,5,100]
        animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]
        >>> pa.RecordBatch.from_arrays([n_legs, animals], names=names).to_pandas()
           n_legs        animals
        0       2       Flamingo
        1       2         Parrot
        2       4            Dog
        3       4          Horse
        4       5  Brittle stars
        5     100      Centipede

        Construct a RecordBatch from pyarrow Arrays using schema:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64()),
        ...     pa.field('animals', pa.string())],
        ...     metadata={"n_legs": "Number of legs per animal"})
        >>> pa.RecordBatch.from_arrays([n_legs, animals], schema=my_schema).to_pandas()
           n_legs        animals
        0       2       Flamingo
        1       2         Parrot
        2       4            Dog
        3       4          Horse
        4       5  Brittle stars
        5     100      Centipede
        >>> pa.RecordBatch.from_arrays([n_legs, animals], schema=my_schema).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'
        """
        cdef:
            Array arr
            shared_ptr[CSchema] c_schema
            vector[shared_ptr[CArray]] c_arrays
            int64_t num_rows

        if len(arrays) > 0:
            num_rows = len(arrays[0])
        else:
            num_rows = 0

        if isinstance(names, Schema):
            import warnings
            warnings.warn("Schema passed to names= option, please "
                          "pass schema= explicitly. "
                          "Will raise exception in future", FutureWarning)
            schema = names
            names = None

        converted_arrays = _sanitize_arrays(arrays, names, schema, metadata,
                                            &c_schema)

        c_arrays.reserve(len(arrays))
        for arr in converted_arrays:
            if len(arr) != num_rows:
                raise ValueError('Arrays were not all the same length: '
                                 f'{len(arr)} vs {num_rows}')
            c_arrays.push_back(arr.sp_array)

        result = pyarrow_wrap_batch(CRecordBatch.Make(c_schema, num_rows,
                                                      c_arrays))
        result.validate()
        return result

    @staticmethod
    def from_struct_array(StructArray struct_array):
        """
        Construct a RecordBatch from a StructArray.

        Each field in the StructArray will become a column in the resulting
        ``RecordBatch``.

        Parameters
        ----------
        struct_array : StructArray
            Array to construct the record batch from.

        Returns
        -------
        pyarrow.RecordBatch

        Examples
        --------
        >>> import pyarrow as pa
        >>> struct = pa.array([{'n_legs': 2, 'animals': 'Parrot'},
        ...                    {'year': 2022, 'n_legs': 4}])
        >>> pa.RecordBatch.from_struct_array(struct).to_pandas()
          animals  n_legs    year
        0  Parrot       2     NaN
        1    None       4  2022.0
        """
        cdef:
            shared_ptr[CRecordBatch] c_record_batch
        if struct_array.sp_array.get().device_type() != CDeviceAllocationType_kCPU:
            raise NotImplementedError("Implemented only for data on CPU device")
        with nogil:
            c_record_batch = GetResultValue(
                CRecordBatch.FromStructArray(struct_array.sp_array))
        return pyarrow_wrap_batch(c_record_batch)

    def to_struct_array(self):
        """
        Convert to a struct array.
        """
        self._assert_cpu()
        cdef:
            shared_ptr[CRecordBatch] c_record_batch
            shared_ptr[CArray] c_array

        c_record_batch = pyarrow_unwrap_batch(self)
        with nogil:
            c_array = GetResultValue(
                <CResult[shared_ptr[CArray]]>deref(c_record_batch).ToStructArray())
        return pyarrow_wrap_array(c_array)

    def to_tensor(self, c_bool null_to_nan=False, c_bool row_major=True, MemoryPool memory_pool=None):
        """
        Convert to a :class:`~pyarrow.Tensor`.

        RecordBatches that can be converted have fields of type signed or unsigned
        integer or float, including all bit-widths.

        ``null_to_nan`` is ``False`` by default and this method will raise an error in case
        any nulls are present. RecordBatches with nulls can be converted with ``null_to_nan``
        set to ``True``. In this case null values are converted to ``NaN`` and integer type
        arrays are promoted to the appropriate float type.

        Parameters
        ----------
        null_to_nan : bool, default False
            Whether to write null values in the result as ``NaN``.
        row_major : bool, default True
            Whether resulting Tensor is row-major or column-major
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool

        Examples
        --------
        >>> import pyarrow as pa
        >>> batch = pa.record_batch(
        ...    [
        ...         pa.array([1, 2, 3, 4, None], type=pa.int32()),
        ...         pa.array([10, 20, 30, 40, None], type=pa.float32()),
        ...     ], names = ["a", "b"]
        ... )

        >>> batch
        pyarrow.RecordBatch
        a: int32
        b: float
        ----
        a: [1,2,3,4,null]
        b: [10,20,30,40,null]

        Convert a RecordBatch to row-major Tensor with null values
        written as ``NaN``s

        >>> batch.to_tensor(null_to_nan=True)
        <pyarrow.Tensor>
        type: double
        shape: (5, 2)
        strides: (16, 8)
        >>> batch.to_tensor(null_to_nan=True).to_numpy()
        array([[ 1., 10.],
               [ 2., 20.],
               [ 3., 30.],
               [ 4., 40.],
               [nan, nan]])

        Convert a RecordBatch to column-major Tensor

        >>> batch.to_tensor(null_to_nan=True, row_major=False)
        <pyarrow.Tensor>
        type: double
        shape: (5, 2)
        strides: (8, 40)
        >>> batch.to_tensor(null_to_nan=True, row_major=False).to_numpy()
        array([[ 1., 10.],
               [ 2., 20.],
               [ 3., 30.],
               [ 4., 40.],
               [nan, nan]])
        """
        self._assert_cpu()
        cdef:
            shared_ptr[CRecordBatch] c_record_batch
            shared_ptr[CTensor] c_tensor
            CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)

        c_record_batch = pyarrow_unwrap_batch(self)
        with nogil:
            c_tensor = GetResultValue(
                <CResult[shared_ptr[CTensor]]>deref(c_record_batch).ToTensor(null_to_nan,
                                                                             row_major, pool))
        return pyarrow_wrap_tensor(c_tensor)

    def copy_to(self, destination):
        """
        Copy the entire RecordBatch to destination device.

        This copies each column of the record batch to create
        a new record batch where all underlying buffers for the columns have
        been copied to the destination MemoryManager.

        Parameters
        ----------
        destination : pyarrow.MemoryManager or pyarrow.Device
            The destination device to copy the array to.

        Returns
        -------
        RecordBatch
        """
        cdef:
            shared_ptr[CRecordBatch] c_batch
            shared_ptr[CMemoryManager] c_memory_manager

        if isinstance(destination, Device):
            c_memory_manager = (<Device>destination).unwrap().get().default_memory_manager()
        elif isinstance(destination, MemoryManager):
            c_memory_manager = (<MemoryManager>destination).unwrap()
        else:
            raise TypeError(
                "Argument 'destination' has incorrect type (expected a "
                f"pyarrow Device or MemoryManager, got {type(destination)})"
            )

        with nogil:
            c_batch = GetResultValue(self.batch.CopyTo(c_memory_manager))
        return pyarrow_wrap_batch(c_batch)

    def _export_to_c(self, out_ptr, out_schema_ptr=0):
        """
        Export to a C ArrowArray struct, given its pointer.

        If a C ArrowSchema struct pointer is also given, the record batch
        schema is exported to it at the same time.

        Parameters
        ----------
        out_ptr: int
            The raw pointer to a C ArrowArray struct.
        out_schema_ptr: int (optional)
            The raw pointer to a C ArrowSchema struct.

        Be careful: if you don't pass the ArrowArray struct to a consumer,
        array memory will leak.  This is a low-level function intended for
        expert users.
        """
        cdef:
            void* c_ptr = _as_c_pointer(out_ptr)
            void* c_schema_ptr = _as_c_pointer(out_schema_ptr,
                                               allow_null=True)
        with nogil:
            check_status(ExportRecordBatch(deref(self.sp_batch),
                                           <ArrowArray*> c_ptr,
                                           <ArrowSchema*> c_schema_ptr))

    @staticmethod
    def _import_from_c(in_ptr, schema):
        """
        Import RecordBatch from a C ArrowArray struct, given its pointer
        and the imported schema.

        Parameters
        ----------
        in_ptr: int
            The raw pointer to a C ArrowArray struct.
        type: Schema or int
            Either a Schema object, or the raw pointer to a C ArrowSchema
            struct.

        This is a low-level function intended for expert users.
        """
        cdef:
            void* c_ptr = _as_c_pointer(in_ptr)
            void* c_schema_ptr
            shared_ptr[CRecordBatch] c_batch

        c_schema = pyarrow_unwrap_schema(schema)
        if c_schema == nullptr:
            # Not a Schema object, perhaps a raw ArrowSchema pointer
            c_schema_ptr = _as_c_pointer(schema, allow_null=True)
            with nogil:
                c_batch = GetResultValue(ImportRecordBatch(
                    <ArrowArray*> c_ptr, <ArrowSchema*> c_schema_ptr))
        else:
            with nogil:
                c_batch = GetResultValue(ImportRecordBatch(
                    <ArrowArray*> c_ptr, c_schema))
        return pyarrow_wrap_batch(c_batch)

    def __arrow_c_array__(self, requested_schema=None):
        """
        Get a pair of PyCapsules containing a C ArrowArray representation of the object.

        Parameters
        ----------
        requested_schema : PyCapsule | None
            A PyCapsule containing a C ArrowSchema representation of a requested
            schema. PyArrow will attempt to cast the batch to this schema.
            If None, the batch will be returned as-is, with a schema matching the
            one returned by :meth:`__arrow_c_schema__()`.

        Returns
        -------
        Tuple[PyCapsule, PyCapsule]
            A pair of PyCapsules containing a C ArrowSchema and ArrowArray,
            respectively.
        """
        self._assert_cpu()
        cdef:
            ArrowArray* c_array
            ArrowSchema* c_schema

        if requested_schema is not None:
            target_schema = Schema._import_from_c_capsule(requested_schema)

            if target_schema != self.schema:
                try:
                    casted_batch = self.cast(target_schema, safe=True)
                    inner_batch = pyarrow_unwrap_batch(casted_batch)
                except ArrowInvalid as e:
                    raise ValueError(
                        f"Could not cast {self.schema} to requested schema {target_schema}: {e}"
                    )
            else:
                inner_batch = self.sp_batch
        else:
            inner_batch = self.sp_batch

        schema_capsule = alloc_c_schema(&c_schema)
        array_capsule = alloc_c_array(&c_array)

        with nogil:
            check_status(ExportRecordBatch(deref(inner_batch), c_array, c_schema))

        return schema_capsule, array_capsule

    def __arrow_c_stream__(self, requested_schema=None):
        """
        Export the batch as an Arrow C stream PyCapsule.

        Parameters
        ----------
        requested_schema : PyCapsule, default None
            The schema to which the stream should be casted, passed as a
            PyCapsule containing a C ArrowSchema representation of the
            requested schema.
            Currently, this is not supported and will raise a
            NotImplementedError if the schema doesn't match the current schema.

        Returns
        -------
        PyCapsule
        """
        self._assert_cpu()
        return Table.from_batches([self]).__arrow_c_stream__(requested_schema)

    @staticmethod
    def _import_from_c_capsule(schema_capsule, array_capsule):
        """
        Import RecordBatch from a pair of PyCapsules containing a C ArrowSchema
        and ArrowArray, respectively.

        Parameters
        ----------
        schema_capsule : PyCapsule
            A PyCapsule containing a C ArrowSchema representation of the schema.
        array_capsule : PyCapsule
            A PyCapsule containing a C ArrowArray representation of the array.

        Returns
        -------
        pyarrow.RecordBatch
        """
        cdef:
            ArrowSchema* c_schema
            ArrowArray* c_array
            shared_ptr[CRecordBatch] c_batch

        c_schema = <ArrowSchema*> PyCapsule_GetPointer(schema_capsule, 'arrow_schema')
        c_array = <ArrowArray*> PyCapsule_GetPointer(array_capsule, 'arrow_array')

        with nogil:
            c_batch = GetResultValue(ImportRecordBatch(c_array, c_schema))

        return pyarrow_wrap_batch(c_batch)

    def _export_to_c_device(self, out_ptr, out_schema_ptr=0):
        """
        Export to a C ArrowDeviceArray struct, given its pointer.

        If a C ArrowSchema struct pointer is also given, the record batch
        schema is exported to it at the same time.

        Parameters
        ----------
        out_ptr: int
            The raw pointer to a C ArrowDeviceArray struct.
        out_schema_ptr: int (optional)
            The raw pointer to a C ArrowSchema struct.

        Be careful: if you don't pass the ArrowDeviceArray struct to a consumer,
        array memory will leak.  This is a low-level function intended for
        expert users.
        """
        cdef:
            void* c_ptr = _as_c_pointer(out_ptr)
            void* c_schema_ptr = _as_c_pointer(out_schema_ptr,
                                               allow_null=True)
        with nogil:
            check_status(ExportDeviceRecordBatch(
                deref(self.sp_batch), <shared_ptr[CSyncEvent]>NULL,
                <ArrowDeviceArray*> c_ptr, <ArrowSchema*> c_schema_ptr)
            )

    @staticmethod
    def _import_from_c_device(in_ptr, schema):
        """
        Import RecordBatch from a C ArrowDeviceArray struct, given its pointer
        and the imported schema.

        Parameters
        ----------
        in_ptr: int
            The raw pointer to a C ArrowDeviceArray struct.
        type: Schema or int
            Either a Schema object, or the raw pointer to a C ArrowSchema
            struct.

        This is a low-level function intended for expert users.
        """
        cdef:
            ArrowDeviceArray* c_device_array = <ArrowDeviceArray*>_as_c_pointer(in_ptr)
            void* c_schema_ptr
            shared_ptr[CRecordBatch] c_batch

        if c_device_array.device_type == ARROW_DEVICE_CUDA:
            _ensure_cuda_loaded()

        c_schema = pyarrow_unwrap_schema(schema)
        if c_schema == nullptr:
            # Not a Schema object, perhaps a raw ArrowSchema pointer
            c_schema_ptr = _as_c_pointer(schema, allow_null=True)
            with nogil:
                c_batch = GetResultValue(ImportDeviceRecordBatch(
                    c_device_array, <ArrowSchema*> c_schema_ptr))
        else:
            with nogil:
                c_batch = GetResultValue(ImportDeviceRecordBatch(
                    c_device_array, c_schema))
        return pyarrow_wrap_batch(c_batch)

    def __arrow_c_device_array__(self, requested_schema=None, **kwargs):
        """
        Get a pair of PyCapsules containing a C ArrowDeviceArray representation
        of the object.

        Parameters
        ----------
        requested_schema : PyCapsule | None
            A PyCapsule containing a C ArrowSchema representation of a requested
            schema. PyArrow will attempt to cast the batch to this data type.
            If None, the batch will be returned as-is, with a type matching the
            one returned by :meth:`__arrow_c_schema__()`.
        kwargs
            Currently no additional keyword arguments are supported, but
            this method will accept any keyword with a value of ``None``
            for compatibility with future keywords.

        Returns
        -------
        Tuple[PyCapsule, PyCapsule]
            A pair of PyCapsules containing a C ArrowSchema and ArrowDeviceArray,
            respectively.
        """
        cdef:
            ArrowDeviceArray* c_array
            ArrowSchema* c_schema
            shared_ptr[CRecordBatch] inner_batch

        non_default_kwargs = [
            name for name, value in kwargs.items() if value is not None
        ]
        if non_default_kwargs:
            raise NotImplementedError(
                f"Received unsupported keyword argument(s): {non_default_kwargs}"
            )

        if requested_schema is not None:
            target_schema = Schema._import_from_c_capsule(requested_schema)

            if target_schema != self.schema:
                if not self.is_cpu:
                    raise NotImplementedError(
                        "Casting to a requested schema is only supported for CPU data"
                    )
                try:
                    casted_batch = self.cast(target_schema, safe=True)
                    inner_batch = pyarrow_unwrap_batch(casted_batch)
                except ArrowInvalid as e:
                    raise ValueError(
                        f"Could not cast {self.schema} to requested schema {target_schema}: {e}"
                    )
            else:
                inner_batch = self.sp_batch
        else:
            inner_batch = self.sp_batch

        schema_capsule = alloc_c_schema(&c_schema)
        array_capsule = alloc_c_device_array(&c_array)

        with nogil:
            check_status(ExportDeviceRecordBatch(
                deref(inner_batch), <shared_ptr[CSyncEvent]>NULL, c_array, c_schema))

        return schema_capsule, array_capsule

    @staticmethod
    def _import_from_c_device_capsule(schema_capsule, array_capsule):
        """
        Import RecordBatch from a pair of PyCapsules containing a
        C ArrowSchema and ArrowDeviceArray, respectively.

        Parameters
        ----------
        schema_capsule : PyCapsule
            A PyCapsule containing a C ArrowSchema representation of the schema.
        array_capsule : PyCapsule
            A PyCapsule containing a C ArrowDeviceArray representation of the array.

        Returns
        -------
        pyarrow.RecordBatch
        """
        cdef:
            ArrowSchema* c_schema
            ArrowDeviceArray* c_array
            shared_ptr[CRecordBatch] batch

        c_schema = <ArrowSchema*> PyCapsule_GetPointer(schema_capsule, 'arrow_schema')
        c_array = <ArrowDeviceArray*> PyCapsule_GetPointer(
            array_capsule, 'arrow_device_array'
        )

        with nogil:
            batch = GetResultValue(ImportDeviceRecordBatch(c_array, c_schema))

        return pyarrow_wrap_batch(batch)

    @property
    def device_type(self):
        """
        The device type where the arrays in the RecordBatch reside.

        Returns
        -------
        DeviceAllocationType
        """
        return _wrap_device_allocation_type(self.sp_batch.get().device_type())

    @property
    def is_cpu(self):
        """
        Whether the RecordBatch's arrays are CPU-accessible.
        """
        return self.device_type == DeviceAllocationType.CPU

    cdef void _assert_cpu(self) except *:
        if self.sp_batch.get().device_type() != CDeviceAllocationType_kCPU:
            raise NotImplementedError("Implemented only for data on CPU device")


def _reconstruct_record_batch(columns, schema):
    """
    Internal: reconstruct RecordBatch from pickled components.
    """
    return RecordBatch.from_arrays(columns, schema=schema)


def table_to_blocks(options, Table table, categories, extension_columns):
    cdef:
        PyObject* result_obj
        shared_ptr[CTable] c_table
        CMemoryPool* pool
        PandasOptions c_options = _convert_pandas_options(options)

    if categories is not None:
        c_options.categorical_columns = make_shared[unordered_set[c_string]](
            unordered_set[c_string]({tobytes(cat) for cat in categories}))
    if extension_columns is not None:
        c_options.extension_columns = make_shared[unordered_set[c_string]](
            unordered_set[c_string]({tobytes(col) for col in extension_columns}))

    if pandas_api.is_v1():
        # ARROW-3789: Coerce date/timestamp types to datetime64[ns]
        c_options.coerce_temporal_nanoseconds = True

    if c_options.self_destruct:
        # Move the shared_ptr, table is now unsafe to use further
        c_table = move(table.sp_table)
        table.table = NULL
    else:
        c_table = table.sp_table

    with nogil:
        check_status(
            libarrow_python.ConvertTableToPandas(c_options, move(c_table),
                                                 &result_obj)
        )

    return PyObject_to_object(result_obj)


cdef class Table(_Tabular):
    """
    A collection of top-level named, equal length Arrow arrays.

    Warnings
    --------
    Do not call this class's constructor directly, use one of the ``from_*``
    methods instead.

    Examples
    --------
    >>> import pyarrow as pa
    >>> n_legs = pa.array([2, 4, 5, 100])
    >>> animals = pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
    >>> names = ["n_legs", "animals"]

    Construct a Table from arrays:

    >>> pa.Table.from_arrays([n_legs, animals], names=names)
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

    Construct a Table from a RecordBatch:

    >>> batch = pa.record_batch([n_legs, animals], names=names)
    >>> pa.Table.from_batches([batch])
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

    Construct a Table from pandas DataFrame:

    >>> import pandas as pd
    >>> df = pd.DataFrame({'year': [2020, 2022, 2019, 2021],
    ...                    'n_legs': [2, 4, 5, 100],
    ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
    >>> pa.Table.from_pandas(df)
    pyarrow.Table
    year: int64
    n_legs: int64
    animals: string
    ----
    year: [[2020,2022,2019,2021]]
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

    Construct a Table from a dictionary of arrays:

    >>> pydict = {'n_legs': n_legs, 'animals': animals}
    >>> pa.Table.from_pydict(pydict)
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
    >>> pa.Table.from_pydict(pydict).schema
    n_legs: int64
    animals: string

    Construct a Table from a dictionary of arrays with metadata:

    >>> my_metadata={"n_legs": "Number of legs per animal"}
    >>> pa.Table.from_pydict(pydict, metadata=my_metadata).schema
    n_legs: int64
    animals: string
    -- schema metadata --
    n_legs: 'Number of legs per animal'

    Construct a Table from a list of rows:

    >>> pylist = [{'n_legs': 2, 'animals': 'Flamingo'}, {'year': 2021, 'animals': 'Centipede'}]
    >>> pa.Table.from_pylist(pylist)
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,null]]
    animals: [["Flamingo","Centipede"]]

    Construct a Table from a list of rows with pyarrow schema:

    >>> my_schema = pa.schema([
    ...     pa.field('year', pa.int64()),
    ...     pa.field('n_legs', pa.int64()),
    ...     pa.field('animals', pa.string())],
    ...     metadata={"year": "Year of entry"})
    >>> pa.Table.from_pylist(pylist, schema=my_schema).schema
    year: int64
    n_legs: int64
    animals: string
    -- schema metadata --
    year: 'Year of entry'

    Construct a Table with :func:`pyarrow.table`:

    >>> pa.table([n_legs, animals], names=names)
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
    """

    def __cinit__(self):
        self.table = NULL
        self._init_is_cpu = False

    cdef void init(self, const shared_ptr[CTable]& table):
        self.sp_table = table
        self.table = table.get()

    def _is_initialized(self):
        return self.table != NULL

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
            self._assert_cpu()
            with nogil:
                check_status(self.table.ValidateFull())
        else:
            with nogil:
                check_status(self.table.Validate())

    def __reduce__(self):
        # Reduce the columns as ChunkedArrays to avoid serializing schema
        # data twice
        self._assert_cpu()
        columns = [col for col in self.columns]
        return _reconstruct_table, (columns, self.schema)

    def slice(self, offset=0, length=None):
        """
        Compute zero-copy slice of this Table.

        Parameters
        ----------
        offset : int, default 0
            Offset from start of table to slice.
        length : int, default None
            Length of slice (default is until end of table starting from
            offset).

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'year': [2020, 2022, 2019, 2021],
        ...                    'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.slice(length=3)
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2020,2022,2019]]
        n_legs: [[2,4,5]]
        animals: [["Flamingo","Horse","Brittle stars"]]
        >>> table.slice(offset=2)
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2019,2021]]
        n_legs: [[5,100]]
        animals: [["Brittle stars","Centipede"]]
        >>> table.slice(offset=2, length=1)
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2019]]
        n_legs: [[5]]
        animals: [["Brittle stars"]]
        """
        cdef shared_ptr[CTable] result

        if offset < 0:
            raise IndexError('Offset must be non-negative')

        offset = min(len(self), offset)
        if length is None:
            result = self.table.Slice(offset)
        else:
            result = self.table.Slice(offset, length)

        return pyarrow_wrap_table(result)

    def select(self, object columns):
        """
        Select columns of the Table.

        Returns a new Table with the specified columns, and metadata
        preserved.

        Parameters
        ----------
        columns : list-like
            The column names or integer indices to select.

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'year': [2020, 2022, 2019, 2021],
        ...                    'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.select([0,1])
        pyarrow.Table
        year: int64
        n_legs: int64
        ----
        year: [[2020,2022,2019,2021]]
        n_legs: [[2,4,5,100]]
        >>> table.select(["year"])
        pyarrow.Table
        year: int64
        ----
        year: [[2020,2022,2019,2021]]
        """
        cdef:
            shared_ptr[CTable] c_table
            vector[int] c_indices

        for idx in columns:
            idx = self._ensure_integer_index(idx)
            idx = _normalize_index(idx, self.num_columns)
            c_indices.push_back(<int> idx)

        with nogil:
            c_table = GetResultValue(self.table.SelectColumns(move(c_indices)))

        return pyarrow_wrap_table(c_table)

    def replace_schema_metadata(self, metadata=None):
        """
        Create shallow copy of table by replacing schema
        key-value metadata with the indicated new metadata (which may be None),
        which deletes any existing metadata.

        Parameters
        ----------
        metadata : dict, default None

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'year': [2020, 2022, 2019, 2021],
        ...                    'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Constructing a Table with pyarrow schema and metadata:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64()),
        ...     pa.field('animals', pa.string())],
        ...     metadata={"n_legs": "Number of legs per animal"})
        >>> table= pa.table(df, my_schema)
        >>> table.schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'
        pandas: ...

        Create a shallow copy of a Table with deleted schema metadata:

        >>> table.replace_schema_metadata().schema
        n_legs: int64
        animals: string

        Create a shallow copy of a Table with new schema metadata:

        >>> metadata={"animals": "Which animal"}
        >>> table.replace_schema_metadata(metadata = metadata).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        animals: 'Which animal'
        """
        cdef:
            shared_ptr[const CKeyValueMetadata] c_meta
            shared_ptr[CTable] c_table

        metadata = ensure_metadata(metadata, allow_none=True)
        c_meta = pyarrow_unwrap_metadata(metadata)
        with nogil:
            c_table = self.table.ReplaceSchemaMetadata(c_meta)

        return pyarrow_wrap_table(c_table)

    def flatten(self, MemoryPool memory_pool=None):
        """
        Flatten this Table.

        Each column with a struct type is flattened
        into one column per struct field.  Other columns are left unchanged.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> struct = pa.array([{'n_legs': 2, 'animals': 'Parrot'},
        ...                    {'year': 2022, 'n_legs': 4}])
        >>> month = pa.array([4, 6])
        >>> table = pa.Table.from_arrays([struct,month],
        ...                              names = ["a", "month"])
        >>> table
        pyarrow.Table
        a: struct<animals: string, n_legs: int64, year: int64>
          child 0, animals: string
          child 1, n_legs: int64
          child 2, year: int64
        month: int64
        ----
        a: [
          -- is_valid: all not null
          -- child 0 type: string
        ["Parrot",null]
          -- child 1 type: int64
        [2,4]
          -- child 2 type: int64
        [null,2022]]
        month: [[4,6]]

        Flatten the columns with struct field:

        >>> table.flatten()
        pyarrow.Table
        a.animals: string
        a.n_legs: int64
        a.year: int64
        month: int64
        ----
        a.animals: [["Parrot",null]]
        a.n_legs: [[2,4]]
        a.year: [[null,2022]]
        month: [[4,6]]
        """
        self._assert_cpu()
        cdef:
            shared_ptr[CTable] flattened
            CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)

        with nogil:
            flattened = GetResultValue(self.table.Flatten(pool))

        return pyarrow_wrap_table(flattened)

    def combine_chunks(self, MemoryPool memory_pool=None):
        """
        Make a new table by combining the chunks this table has.

        All the underlying chunks in the ChunkedArray of each column are
        concatenated into zero or one chunk.

        To avoid buffer overflow, binary columns may be combined into
        multiple chunks. Chunks will have the maximum possible length.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool.

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
        >>> animals = pa.chunked_array([["Flamingo", "Parrot", "Dog"], ["Horse", "Brittle stars", "Centipede"]])
        >>> names = ["n_legs", "animals"]
        >>> table = pa.table([n_legs, animals], names=names)
        >>> table
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,2,4],[4,5,100]]
        animals: [["Flamingo","Parrot","Dog"],["Horse","Brittle stars","Centipede"]]
        >>> table.combine_chunks()
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,2,4,4,5,100]]
        animals: [["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]]
        """
        self._assert_cpu()
        cdef:
            shared_ptr[CTable] combined
            CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)

        with nogil:
            combined = GetResultValue(self.table.CombineChunks(pool))

        return pyarrow_wrap_table(combined)

    def unify_dictionaries(self, MemoryPool memory_pool=None):
        """
        Unify dictionaries across all chunks.

        This method returns an equivalent table, but where all chunks of
        each column share the same dictionary values.  Dictionary indices
        are transposed accordingly.

        Columns without dictionaries are returned unchanged.

        Parameters
        ----------
        memory_pool : MemoryPool, default None
            For memory allocations, if required, otherwise use default pool

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> arr_1 = pa.array(["Flamingo", "Parrot", "Dog"]).dictionary_encode()
        >>> arr_2 = pa.array(["Horse", "Brittle stars", "Centipede"]).dictionary_encode()
        >>> c_arr = pa.chunked_array([arr_1, arr_2])
        >>> table = pa.table([c_arr], names=["animals"])
        >>> table
        pyarrow.Table
        animals: dictionary<values=string, indices=int32, ordered=0>
        ----
        animals: [  -- dictionary:
        ["Flamingo","Parrot","Dog"]  -- indices:
        [0,1,2],  -- dictionary:
        ["Horse","Brittle stars","Centipede"]  -- indices:
        [0,1,2]]

        Unify dictionaries across both chunks:

        >>> table.unify_dictionaries()
        pyarrow.Table
        animals: dictionary<values=string, indices=int32, ordered=0>
        ----
        animals: [  -- dictionary:
        ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]  -- indices:
        [0,1,2],  -- dictionary:
        ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]  -- indices:
        [3,4,5]]
        """
        self._assert_cpu()
        cdef:
            CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)
            shared_ptr[CTable] c_result

        with nogil:
            c_result = GetResultValue(CDictionaryUnifier.UnifyTable(
                deref(self.table), pool))

        return pyarrow_wrap_table(c_result)

    def equals(self, Table other, bint check_metadata=False):
        """
        Check if contents of two tables are equal.

        Parameters
        ----------
        other : pyarrow.Table
            Table to compare against.
        check_metadata : bool, default False
            Whether schema metadata equality should be checked as well.

        Returns
        -------
        bool

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
        >>> names=["n_legs", "animals"]
        >>> table = pa.Table.from_arrays([n_legs, animals], names=names)
        >>> table_0 = pa.Table.from_arrays([])
        >>> table_1 = pa.Table.from_arrays([n_legs, animals],
        ...                                 names=names,
        ...                                 metadata={"n_legs": "Number of legs per animal"})
        >>> table.equals(table)
        True
        >>> table.equals(table_0)
        False
        >>> table.equals(table_1)
        True
        >>> table.equals(table_1, check_metadata=True)
        False
        """
        self._assert_cpu()
        if other is None:
            return False

        cdef:
            CTable* this_table = self.table
            CTable* other_table = other.table
            c_bool result

        with nogil:
            result = this_table.Equals(deref(other_table), check_metadata)

        return result

    def cast(self, Schema target_schema, safe=None, options=None):
        """
        Cast table values to another schema.

        Parameters
        ----------
        target_schema : Schema
            Schema to cast to, the names and order of fields must match.
        safe : bool, default True
            Check for overflows or other unsafe conversions.
        options : CastOptions, default None
            Additional checks pass by CastOptions

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.schema
        n_legs: int64
        animals: string
        -- schema metadata --
        pandas: '{"index_columns": [{"kind": "range", "name": null, "start": 0, ...

        Define new schema and cast table values:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.duration('s')),
        ...     pa.field('animals', pa.string())]
        ...     )
        >>> table.cast(target_schema=my_schema)
        pyarrow.Table
        n_legs: duration[s]
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        """
        self._assert_cpu()
        cdef:
            ChunkedArray column, casted
            Field field
            list newcols = []

        if self.schema.names != target_schema.names:
            raise ValueError(f"Target schema's field names are not matching "
                             f"the table's field names: {self.schema.names!r}, {target_schema.names!r}")

        for column, field in zip(self.itercolumns(), target_schema):
            if not field.nullable and column.null_count > 0:
                raise ValueError(
                    f"Casting field {field.name!r} with null values to non-nullable")
            casted = column.cast(field.type, safe=safe, options=options)
            newcols.append(casted)

        return Table.from_arrays(newcols, schema=target_schema)

    @classmethod
    def from_pandas(cls, df, Schema schema=None, preserve_index=None,
                    nthreads=None, columns=None, bint safe=True):
        """
        Convert pandas.DataFrame to an Arrow Table.

        The column types in the resulting Arrow Table are inferred from the
        dtypes of the pandas.Series in the DataFrame. In the case of non-object
        Series, the NumPy dtype is translated to its Arrow equivalent. In the
        case of `object`, we need to guess the datatype by looking at the
        Python objects in this Series.

        Be aware that Series of the `object` dtype don't carry enough
        information to always lead to a meaningful Arrow type. In the case that
        we cannot infer a type, e.g. because the DataFrame is of length 0 or
        the Series only contains None/nan objects, the type is set to
        null. This behavior can be avoided by constructing an explicit schema
        and passing it to this function.

        Parameters
        ----------
        df : pandas.DataFrame
        schema : pyarrow.Schema, optional
            The expected schema of the Arrow Table. This can be used to
            indicate the type of columns if we cannot infer it automatically.
            If passed, the output will have exactly this schema. Columns
            specified in the schema that are not found in the DataFrame columns
            or its index will raise an error. Additional columns or index
            levels in the DataFrame which are not specified in the schema will
            be ignored.
        preserve_index : bool, optional
            Whether to store the index as an additional column in the resulting
            ``Table``. The default of None will store the index as a column,
            except for RangeIndex which is stored as metadata only. Use
            ``preserve_index=True`` to force it to be stored as a column.
        nthreads : int, default None
            If greater than 1, convert columns to Arrow in parallel using
            indicated number of threads. By default, this follows
            :func:`pyarrow.cpu_count` (may use up to system CPU count threads).
        columns : list, optional
           List of column to be converted. If None, use all columns.
        safe : bool, default True
           Check for overflows or other unsafe conversions.

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> pa.Table.from_pandas(df)
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        """
        from pyarrow.pandas_compat import dataframe_to_arrays
        arrays, schema, n_rows = dataframe_to_arrays(
            df,
            schema=schema,
            preserve_index=preserve_index,
            nthreads=nthreads,
            columns=columns,
            safe=safe
        )

        # If df is empty but row index is not, create empty Table with rows >0
        cdef vector[shared_ptr[CChunkedArray]] c_arrays
        if n_rows:
            return pyarrow_wrap_table(
                CTable.MakeWithRows((<Schema> schema).sp_schema, c_arrays, n_rows))
        else:
            return cls.from_arrays(arrays, schema=schema)

    @staticmethod
    def from_arrays(arrays, names=None, schema=None, metadata=None):
        """
        Construct a Table from Arrow arrays.

        Parameters
        ----------
        arrays : list of pyarrow.Array or pyarrow.ChunkedArray
            Equal-length arrays that should form the table.
        names : list of str, optional
            Names for the table columns. If not passed, schema must be passed.
        schema : Schema, default None
            Schema for the created table. If not passed, names must be passed.
        metadata : dict or Mapping, default None
            Optional metadata for the schema (if inferred).

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
        >>> names = ["n_legs", "animals"]

        Construct a Table from arrays:

        >>> pa.Table.from_arrays([n_legs, animals], names=names)
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

        Construct a Table from arrays with metadata:

        >>> my_metadata={"n_legs": "Number of legs per animal"}
        >>> pa.Table.from_arrays([n_legs, animals],
        ...                       names=names,
        ...                       metadata=my_metadata)
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        >>> pa.Table.from_arrays([n_legs, animals],
        ...                       names=names,
        ...                       metadata=my_metadata).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        n_legs: 'Number of legs per animal'

        Construct a Table from arrays with pyarrow schema:

        >>> my_schema = pa.schema([
        ...     pa.field('n_legs', pa.int64()),
        ...     pa.field('animals', pa.string())],
        ...     metadata={"animals": "Name of the animal species"})
        >>> pa.Table.from_arrays([n_legs, animals],
        ...                       schema=my_schema)
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        >>> pa.Table.from_arrays([n_legs, animals],
        ...                       schema=my_schema).schema
        n_legs: int64
        animals: string
        -- schema metadata --
        animals: 'Name of the animal species'
        """
        cdef:
            vector[shared_ptr[CChunkedArray]] columns
            shared_ptr[CSchema] c_schema
            int i, K = <int> len(arrays)

        converted_arrays = _sanitize_arrays(arrays, names, schema, metadata,
                                            &c_schema)

        columns.reserve(K)
        for item in converted_arrays:
            if isinstance(item, Array):
                columns.push_back(
                    make_shared[CChunkedArray](
                        (<Array> item).sp_array
                    )
                )
            elif isinstance(item, ChunkedArray):
                columns.push_back((<ChunkedArray> item).sp_chunked_array)
            else:
                raise TypeError(type(item))

        result = pyarrow_wrap_table(CTable.Make(c_schema, columns))
        result.validate()
        return result

    @staticmethod
    def from_struct_array(struct_array):
        """
        Construct a Table from a StructArray.

        Each field in the StructArray will become a column in the resulting
        ``Table``.

        Parameters
        ----------
        struct_array : StructArray or ChunkedArray
            Array to construct the table from.

        Returns
        -------
        pyarrow.Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> struct = pa.array([{'n_legs': 2, 'animals': 'Parrot'},
        ...                    {'year': 2022, 'n_legs': 4}])
        >>> pa.Table.from_struct_array(struct).to_pandas()
          animals  n_legs    year
        0  Parrot       2     NaN
        1    None       4  2022.0
        """
        if isinstance(struct_array, Array):
            return Table.from_batches([RecordBatch.from_struct_array(struct_array)])
        else:
            return Table.from_batches([
                RecordBatch.from_struct_array(chunk)
                for chunk in struct_array.chunks
            ])

    def to_struct_array(self, max_chunksize=None):
        """
        Convert to a chunked array of struct type.

        Parameters
        ----------
        max_chunksize : int, default None
            Maximum number of rows for ChunkedArray chunks. Individual chunks
            may be smaller depending on the chunk layout of individual columns.

        Returns
        -------
        ChunkedArray
        """
        self._assert_cpu()
        chunks = [
            batch.to_struct_array()
            for batch in self.to_batches(max_chunksize=max_chunksize)
        ]
        return chunked_array(chunks, type=struct(self.schema))

    @staticmethod
    def from_batches(batches, Schema schema=None):
        """
        Construct a Table from a sequence or iterator of Arrow RecordBatches.

        Parameters
        ----------
        batches : sequence or iterator of RecordBatch
            Sequence of RecordBatch to be converted, all schemas must be equal.
        schema : Schema, default None
            If not passed, will be inferred from the first RecordBatch.

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> n_legs = pa.array([2, 4, 5, 100])
        >>> animals = pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
        >>> names = ["n_legs", "animals"]
        >>> batch = pa.record_batch([n_legs, animals], names=names)
        >>> batch.to_pandas()
           n_legs        animals
        0       2       Flamingo
        1       4          Horse
        2       5  Brittle stars
        3     100      Centipede

        Construct a Table from a RecordBatch:

        >>> pa.Table.from_batches([batch])
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

        Construct a Table from a sequence of RecordBatches:

        >>> pa.Table.from_batches([batch, batch])
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100],[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"],["Flamingo","Horse","Brittle stars","Centipede"]]
        """
        cdef:
            vector[shared_ptr[CRecordBatch]] c_batches
            shared_ptr[CTable] c_table
            shared_ptr[CSchema] c_schema
            RecordBatch batch

        for batch in batches:
            c_batches.push_back(batch.sp_batch)

        if schema is None:
            if c_batches.size() == 0:
                raise ValueError('Must pass schema, or at least '
                                 'one RecordBatch')
            c_schema = c_batches[0].get().schema()
        else:
            c_schema = schema.sp_schema

        with nogil:
            c_table = GetResultValue(
                CTable.FromRecordBatches(c_schema, move(c_batches)))

        return pyarrow_wrap_table(c_table)

    def to_batches(self, max_chunksize=None):
        """
        Convert Table to a list of RecordBatch objects.

        Note that this method is zero-copy, it merely exposes the same data
        under a different API.

        Parameters
        ----------
        max_chunksize : int, default None
            Maximum number of rows for each RecordBatch chunk. Individual chunks
            may be smaller depending on the chunk layout of individual columns.

        Returns
        -------
        list[RecordBatch]

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Convert a Table to a RecordBatch:

        >>> table.to_batches()[0].to_pandas()
           n_legs        animals
        0       2       Flamingo
        1       4          Horse
        2       5  Brittle stars
        3     100      Centipede

        Convert a Table to a list of RecordBatches:

        >>> table.to_batches(max_chunksize=2)[0].to_pandas()
           n_legs   animals
        0       2  Flamingo
        1       4     Horse
        >>> table.to_batches(max_chunksize=2)[1].to_pandas()
           n_legs        animals
        0       5  Brittle stars
        1     100      Centipede
        """
        cdef:
            unique_ptr[TableBatchReader] reader
            int64_t c_max_chunksize
            list result = []
            shared_ptr[CRecordBatch] batch

        reader.reset(new TableBatchReader(deref(self.table)))

        if max_chunksize is not None:
            if not max_chunksize > 0:
                raise ValueError("'max_chunksize' should be strictly positive")
            c_max_chunksize = max_chunksize
            reader.get().set_chunksize(c_max_chunksize)

        while True:
            with nogil:
                check_status(reader.get().ReadNext(&batch))

            if batch.get() == NULL:
                break

            result.append(pyarrow_wrap_batch(batch))

        return result

    def to_reader(self, max_chunksize=None):
        """
        Convert the Table to a RecordBatchReader.

        Note that this method is zero-copy, it merely exposes the same data
        under a different API.

        Parameters
        ----------
        max_chunksize : int, default None
            Maximum number of rows for each RecordBatch chunk. Individual chunks
            may be smaller depending on the chunk layout of individual columns.

        Returns
        -------
        RecordBatchReader

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Convert a Table to a RecordBatchReader:

        >>> table.to_reader()
        <pyarrow.lib.RecordBatchReader object at ...>

        >>> reader = table.to_reader()
        >>> reader.schema
        n_legs: int64
        animals: string
        -- schema metadata --
        pandas: '{"index_columns": [{"kind": "range", "name": null, "start": 0, ...
        >>> reader.read_all()
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        """
        cdef:
            shared_ptr[CRecordBatchReader] c_reader
            RecordBatchReader reader
            shared_ptr[TableBatchReader] t_reader
        t_reader = make_shared[TableBatchReader](self.sp_table)

        if max_chunksize is not None:
            t_reader.get().set_chunksize(max_chunksize)

        c_reader = dynamic_pointer_cast[CRecordBatchReader, TableBatchReader](
            t_reader)
        reader = RecordBatchReader.__new__(RecordBatchReader)
        reader.reader = c_reader
        return reader

    def _to_pandas(self, options, categories=None, ignore_metadata=False,
                   types_mapper=None):
        self._assert_cpu()
        from pyarrow.pandas_compat import table_to_dataframe
        df = table_to_dataframe(
            options, self, categories,
            ignore_metadata=ignore_metadata,
            types_mapper=types_mapper)
        return df

    @property
    def schema(self):
        """
        Schema of the table and its columns.

        Returns
        -------
        Schema

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.schema
        n_legs: int64
        animals: string
        -- schema metadata --
        pandas: '{"index_columns": [{"kind": "range", "name": null, "start": 0, "' ...
        """
        return pyarrow_wrap_schema(self.table.schema())

    def _column(self, int i):
        """
        Select a column by its numeric index.

        Parameters
        ----------
        i : int
            The index of the column to retrieve.

        Returns
        -------
        ChunkedArray
        """
        cdef int index = <int> _normalize_index(i, self.num_columns)
        cdef ChunkedArray result = pyarrow_wrap_chunked_array(
            self.table.column(index))
        result._name = self.schema[index].name
        return result

    @property
    def num_columns(self):
        """
        Number of columns in this table.

        Returns
        -------
        int

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [None, 4, 5, None],
        ...                    'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.num_columns
        2
        """
        return self.table.num_columns()

    @property
    def num_rows(self):
        """
        Number of rows in this table.

        Due to the definition of a table, all columns have the same number of
        rows.

        Returns
        -------
        int

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [None, 4, 5, None],
        ...                    'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.num_rows
        4
        """
        return self.table.num_rows()

    @property
    def nbytes(self):
        """
        Total number of bytes consumed by the elements of the table.

        In other words, the sum of bytes from all buffer ranges referenced.

        Unlike `get_total_buffer_size` this method will account for array
        offsets.

        If buffers are shared between arrays then the shared
        portion will only be counted multiple times.

        The dictionary of dictionary arrays will always be counted in their
        entirety even if the array only references a portion of the dictionary.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [None, 4, 5, None],
        ...                    'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.nbytes
        72
        """
        self._assert_cpu()
        cdef:
            CResult[int64_t] c_res_buffer

        with nogil:
            c_res_buffer = ReferencedBufferSize(deref(self.table))
            size = GetResultValue(c_res_buffer)
        return size

    def get_total_buffer_size(self):
        """
        The sum of bytes in each buffer referenced by the table.

        An array may only reference a portion of a buffer.
        This method will overestimate in this case and return the
        byte size of the entire buffer.

        If a buffer is referenced multiple times then it will
        only be counted once.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [None, 4, 5, None],
        ...                    'animals': ["Flamingo", "Horse", None, "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.get_total_buffer_size()
        76
        """
        self._assert_cpu()
        cdef:
            int64_t total_buffer_size

        total_buffer_size = TotalBufferSize(deref(self.table))
        return total_buffer_size

    def __sizeof__(self):
        return super(Table, self).__sizeof__() + self.nbytes

    def add_column(self, int i, field_, column):
        """
        Add column to Table at position.

        A new table is returned with the column added, the original table
        object is left unchanged.

        Parameters
        ----------
        i : int
            Index to place the column at.
        field_ : str or Field
            If a string is passed then the type is deduced from the column
            data.
        column : Array, list of Array, or values coercible to arrays
            Column data.

        Returns
        -------
        Table
            New table with the passed column added.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Add column:

        >>> year = [2021, 2022, 2019, 2021]
        >>> table.add_column(0,"year", [year])
        pyarrow.Table
        year: int64
        n_legs: int64
        animals: string
        ----
        year: [[2021,2022,2019,2021]]
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

        Original table is left unchanged:

        >>> table
        pyarrow.Table
        n_legs: int64
        animals: string
        ----
        n_legs: [[2,4,5,100]]
        animals: [["Flamingo","Horse","Brittle stars","Centipede"]]
        """
        cdef:
            shared_ptr[CTable] c_table
            Field c_field
            ChunkedArray c_arr

        if isinstance(column, ChunkedArray):
            c_arr = column
        else:
            c_arr = chunked_array(column)

        if isinstance(field_, Field):
            c_field = field_
        else:
            c_field = field(field_, c_arr.type)

        with nogil:
            c_table = GetResultValue(self.table.AddColumn(
                i, c_field.sp_field, c_arr.sp_chunked_array))

        return pyarrow_wrap_table(c_table)

    def remove_column(self, int i):
        """
        Create new Table with the indicated column removed.

        Parameters
        ----------
        i : int
            Index of column to remove.

        Returns
        -------
        Table
            New table without the column.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.remove_column(1)
        pyarrow.Table
        n_legs: int64
        ----
        n_legs: [[2,4,5,100]]
        """
        cdef shared_ptr[CTable] c_table

        with nogil:
            c_table = GetResultValue(self.table.RemoveColumn(i))

        return pyarrow_wrap_table(c_table)

    def set_column(self, int i, field_, column):
        """
        Replace column in Table at position.

        Parameters
        ----------
        i : int
            Index to place the column at.
        field_ : str or Field
            If a string is passed then the type is deduced from the column
            data.
        column : Array, list of Array, or values coercible to arrays
            Column data.

        Returns
        -------
        Table
            New table with the passed column set.

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)

        Replace a column:

        >>> year = [2021, 2022, 2019, 2021]
        >>> table.set_column(1,'year', [year])
        pyarrow.Table
        n_legs: int64
        year: int64
        ----
        n_legs: [[2,4,5,100]]
        year: [[2021,2022,2019,2021]]
        """
        cdef:
            shared_ptr[CTable] c_table
            Field c_field
            ChunkedArray c_arr

        if isinstance(column, ChunkedArray):
            c_arr = column
        else:
            c_arr = chunked_array(column)

        if isinstance(field_, Field):
            c_field = field_
        else:
            c_field = field(field_, c_arr.type)

        with nogil:
            c_table = GetResultValue(self.table.SetColumn(
                i, c_field.sp_field, c_arr.sp_chunked_array))

        return pyarrow_wrap_table(c_table)

    def rename_columns(self, names):
        """
        Create new table with columns renamed to provided names.

        Parameters
        ----------
        names : list[str] or dict[str, str]
            List of new column names or mapping of old column names to new column names.

            If a mapping of old to new column names is passed, then all columns which are
            found to match a provided old column name will be renamed to the new column name.
            If any column names are not found in the mapping, a KeyError will be raised.

        Raises
        ------
        KeyError
            If any of the column names passed in the names mapping do not exist.

        Returns
        -------
        Table

        Examples
        --------
        >>> import pyarrow as pa
        >>> import pandas as pd
        >>> df = pd.DataFrame({'n_legs': [2, 4, 5, 100],
        ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> new_names = ["n", "name"]
        >>> table.rename_columns(new_names)
        pyarrow.Table
        n: int64
        name: string
        ----
        n: [[2,4,5,100]]
        name: [["Flamingo","Horse","Brittle stars","Centipede"]]
        >>> new_names = {"n_legs": "n", "animals": "name"}
        >>> table.rename_columns(new_names)
        pyarrow.Table
        n: int64
        name: string
        ----
        n: [[2,4,5,100]]
        name: [["Flamingo","Horse","Brittle stars","Centipede"]]
        """
        cdef:
            shared_ptr[CTable] c_table
            vector[c_string] c_names

        if isinstance(names, (list, tuple)):
            for name in names:
                c_names.push_back(tobytes(name))
        elif isinstance(names, dict):
            idx_to_new_name = {}
            for name, new_name in names.items():
                indices = self.schema.get_all_field_indices(name)

                if not indices:
                    raise KeyError(f"Column {name!r} not found")

                for index in indices:
                    idx_to_new_name[index] = new_name

            for i in range(self.num_columns):
                c_names.push_back(tobytes(idx_to_new_name.get(i, self.schema[i].name)))
        else:
            raise TypeError(f"names must be a list or dict not {type(names)!r}")

        with nogil:
            c_table = GetResultValue(self.table.RenameColumns(move(c_names)))

        return pyarrow_wrap_table(c_table)

    def drop(self, columns):
        """
        Drop one or more columns and return a new table.

        Alias of Table.drop_columns, but kept for backwards compatibility.

        Parameters
        ----------
        columns : str or list[str]
            Field name(s) referencing existing column(s).

        Returns
        -------
        Table
            New table without the column(s).
        """
        return self.drop_columns(columns)

    def group_by(self, keys, use_threads=True):
        """
        Declare a grouping over the columns of the table.

        Resulting grouping can then be used to perform aggregations
        with a subsequent ``aggregate()`` method.

        Parameters
        ----------
        keys : str or list[str]
            Name of the columns that should be used as the grouping key.
        use_threads : bool, default True
            Whether to use multithreading or not. When set to True (the
            default), no stable ordering of the output is guaranteed.

        Returns
        -------
        TableGroupBy

        See Also
        --------
        TableGroupBy.aggregate

        Examples
        --------
        >>> import pandas as pd
        >>> import pyarrow as pa
        >>> df = pd.DataFrame({'year': [2020, 2022, 2021, 2022, 2019, 2021],
        ...                    'n_legs': [2, 2, 4, 4, 5, 100],
        ...                    'animal': ["Flamingo", "Parrot", "Dog", "Horse",
        ...                    "Brittle stars", "Centipede"]})
        >>> table = pa.Table.from_pandas(df)
        >>> table.group_by('year').aggregate([('n_legs', 'sum')])
        pyarrow.Table
        year: int64
        n_legs_sum: int64
        ----
        year: [[2020,2022,2021,2019]]
        n_legs_sum: [[2,6,104,5]]
        """
        self._assert_cpu()
        return TableGroupBy(self, keys, use_threads=use_threads)

    def join(self, right_table, keys, right_keys=None, join_type="left outer",
             left_suffix=None, right_suffix=None, coalesce_keys=True,
             use_threads=True, filter_expression=None):
        """
        Perform a join between this table and another one.

        Result of the join will be a new Table, where further
        operations can be applied.

        Parameters
        ----------
        right_table : Table
            The table to join to the current one, acting as the right table
            in the join operation.
        keys : str or list[str]
            The columns from current table that should be used as keys
            of the join operation left side.
        right_keys : str or list[str], default None
            The columns from the right_table that should be used as keys
            on the join operation right side.
            When ``None`` use the same key names as the left table.
        join_type : str, default "left outer"
            The kind of join that should be performed, one of
            ("left semi", "right semi", "left anti", "right anti",
            "inner", "left outer", "right outer", "full outer")
        left_suffix : str, default None
            Which suffix to add to left column names. This prevents confusion
            when the columns in left and right tables have colliding names.
        right_suffix : str, default None
            Which suffix to add to the right column names. This prevents confusion
            when the columns in left and right tables have colliding names.
        coalesce_keys : bool, default True
            If the duplicated keys should be omitted from one of the sides
            in the join result.
        use_threads : bool, default True
            Whether to use multithreading or not.
        filter_expression : pyarrow.compute.Expression
            Residual filter which is applied to matching row.

        Returns
        -------
        Table

        Examples
        --------
        >>> import pandas as pd
        >>> import pyarrow as pa
        >>> import pyarrow.compute as pc
        >>> df1 = pd.DataFrame({'id': [1, 2, 3],
        ...                     'year': [2020, 2022, 2019]})
        >>> df2 = pd.DataFrame({'id': [3, 4],
        ...                     'n_legs': [5, 100],
        ...                     'animal': ["Brittle stars", "Centipede"]})
        >>> t1 = pa.Table.from_pandas(df1)
        >>> t2 = pa.Table.from_pandas(df2)

        Left outer join:

        >>> t1.join(t2, 'id').combine_chunks().sort_by('year')
        pyarrow.Table
        id: int64
        year: int64
        n_legs: int64
        animal: string
        ----
        id: [[3,1,2]]
        year: [[2019,2020,2022]]
        n_legs: [[5,null,null]]
        animal: [["Brittle stars",null,null]]

        Full outer join:

        >>> t1.join(t2, 'id', join_type="full outer").combine_chunks().sort_by('year')
        pyarrow.Table
        id: int64
        year: int64
        n_legs: int64
        animal: string
        ----
        id: [[3,1,2,4]]
        year: [[2019,2020,2022,null]]
        n_legs: [[5,null,null,100]]
        animal: [["Brittle stars",null,null,"Centipede"]]

        Right outer join:

        >>> t1.join(t2, 'id', join_type="right outer").combine_chunks().sort_by('year')
        pyarrow.Table
        year: int64
        id: int64
        n_legs: int64
        animal: string
        ----
        year: [[2019,null]]
        id: [[3,4]]
        n_legs: [[5,100]]
        animal: [["Brittle stars","Centipede"]]

        Right anti join:

        >>> t1.join(t2, 'id', join_type="right anti")
        pyarrow.Table
        id: int64
        n_legs: int64
        animal: string
        ----
        id: [[4]]
        n_legs: [[100]]
        animal: [["Centipede"]]

        Inner join with intended mismatch filter expression:

        >>> t1.join(t2, 'id', join_type="inner", filter_expression=pc.equal(pc.field("n_legs"), 100))
        pyarrow.Table
        id: int64
        year: int64
        n_legs: int64
        animal: string
        ----
        id: []
        year: []
        n_legs: []
        animal: []
        """
        self._assert_cpu()
        if right_keys is None:
            right_keys = keys
        return _pac()._perform_join(
            join_type, self, keys, right_table, right_keys,
            left_suffix=left_suffix, right_suffix=right_suffix,
            use_threads=use_threads, coalesce_keys=coalesce_keys,
            output_type=Table,
            filter_expression=filter_expression,
        )

    def join_asof(self, right_table, on, by, tolerance, right_on=None, right_by=None):
        """
        Perform an asof join between this table and another one.

        This is similar to a left-join except that we match on nearest key rather
        than equal keys. Both tables must be sorted by the key. This type of join
        is most useful for time series data that are not perfectly aligned.

        Optionally match on equivalent keys with "by" before searching with "on".

        Result of the join will be a new Table, where further
        operations can be applied.

        Parameters
        ----------
        right_table : Table
            The table to join to the current one, acting as the right table
            in the join operation.
        on : str
            The column from current table that should be used as the "on" key
            of the join operation left side.

            An inexact match is used on the "on" key, i.e. a row is considered a
            match if and only if ``right.on - left.on`` is in the range
            ``[min(0, tolerance), max(0, tolerance)]``.

            The input dataset must be sorted by the "on" key. Must be a single
            field of a common type.

            Currently, the "on" key must be an integer, date, or timestamp type.
        by : str or list[str]
            The columns from current table that should be used as the keys
            of the join operation left side. The join operation is then done
            only for the matches in these columns.
        tolerance : int
            The tolerance for inexact "on" key matching. A right row is considered
            a match with a left row if ``right.on - left.on`` is in the range
            ``[min(0, tolerance), max(0, tolerance)]``. ``tolerance`` may be:

            - negative, in which case a past-as-of-join occurs
              (match iff ``tolerance <= right.on - left.on <= 0``);
            - or positive, in which case a future-as-of-join occurs
              (match iff ``0 <= right.on - left.on <= tolerance``);
            - or zero, in which case an exact-as-of-join occurs
              (match iff ``right.on == left.on``).

            The tolerance is interpreted in the same units as the "on" key.
        right_on : str or list[str], default None
            The columns from the right_table that should be used as the on key
            on the join operation right side.
            When ``None`` use the same key name as the left table.
        right_by : str or list[str], default None
            The columns from the right_table that should be used as keys
            on the join operation right side.
            When ``None`` use the same key names as the left table.

        Returns
        -------
        Table

        Example
        --------
        >>> import pyarrow as pa
        >>> t1 = pa.table({'id': [1, 3, 2, 3, 3],
        ...                'year': [2020, 2021, 2022, 2022, 2023]})
        >>> t2 = pa.table({'id': [3, 4],
        ...                'year': [2020, 2021],
        ...                'n_legs': [5, 100],
        ...                'animal': ["Brittle stars", "Centipede"]})

        >>> t1.join_asof(t2, on='year', by='id', tolerance=-2)
        pyarrow.Table
        id: int64
        year: int64
        n_legs: int64
        animal: string
        ----
        id: [[1,3,2,3,3]]
        year: [[2020,2021,2022,2022,2023]]
        n_legs: [[null,5,null,5,null]]
        animal: [[null,"Brittle stars",null,"Brittle stars",null]]
        """
        self._assert_cpu()
        if right_on is None:
            right_on = on
        if right_by is None:
            right_by = by
        return _pac()._perform_join_asof(self, on, by,
                                         right_table, right_on, right_by,
                                         tolerance, output_type=Table)

    def __arrow_c_stream__(self, requested_schema=None):
        """
        Export the table as an Arrow C stream PyCapsule.

        Parameters
        ----------
        requested_schema : PyCapsule, default None
            The schema to which the stream should be casted, passed as a
            PyCapsule containing a C ArrowSchema representation of the
            requested schema.
            Currently, this is not supported and will raise a
            NotImplementedError if the schema doesn't match the current schema.

        Returns
        -------
        PyCapsule
        """
        self._assert_cpu()
        return self.to_reader().__arrow_c_stream__(requested_schema)

    @property
    def is_cpu(self):
        """
        Whether all ChunkedArrays are CPU-accessible.
        """
        if not self._init_is_cpu:
            self._is_cpu = all(c.is_cpu for c in self.itercolumns())
            self._init_is_cpu = True
        return self._is_cpu

    cdef void _assert_cpu(self) except *:
        if not self.is_cpu:
            raise NotImplementedError("Implemented only for data on CPU device")


def _reconstruct_table(arrays, schema):
    """
    Internal: reconstruct pa.Table from pickled components.
    """
    return Table.from_arrays(arrays, schema=schema)


def record_batch(data, names=None, schema=None, metadata=None):
    """
    Create a pyarrow.RecordBatch from another Python data structure or sequence
    of arrays.

    Parameters
    ----------
    data : dict, list, pandas.DataFrame, Arrow-compatible table
        A mapping of strings to Arrays or Python lists, a list of Arrays,
        a pandas DataFame, or any tabular object implementing the
        Arrow PyCapsule Protocol (has an ``__arrow_c_array__`` or
        ``__arrow_c_device_array__`` method).
    names : list, default None
        Column names if list of arrays passed as data. Mutually exclusive with
        'schema' argument.
    schema : Schema, default None
        The expected schema of the RecordBatch. If not passed, will be inferred
        from the data. Mutually exclusive with 'names' argument.
    metadata : dict or Mapping, default None
        Optional metadata for the schema (if schema not passed).

    Returns
    -------
    RecordBatch

    See Also
    --------
    RecordBatch.from_arrays, RecordBatch.from_pandas, table

    Examples
    --------
    >>> import pyarrow as pa
    >>> n_legs = pa.array([2, 2, 4, 4, 5, 100])
    >>> animals = pa.array(["Flamingo", "Parrot", "Dog", "Horse", "Brittle stars", "Centipede"])
    >>> names = ["n_legs", "animals"]

    Construct a RecordBatch from a python dictionary:

    >>> pa.record_batch({"n_legs": n_legs, "animals": animals})
    pyarrow.RecordBatch
    n_legs: int64
    animals: string
    ----
    n_legs: [2,2,4,4,5,100]
    animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]
    >>> pa.record_batch({"n_legs": n_legs, "animals": animals}).to_pandas()
       n_legs        animals
    0       2       Flamingo
    1       2         Parrot
    2       4            Dog
    3       4          Horse
    4       5  Brittle stars
    5     100      Centipede

    Creating a RecordBatch from a list of arrays with names:

    >>> pa.record_batch([n_legs, animals], names=names)
    pyarrow.RecordBatch
    n_legs: int64
    animals: string
    ----
    n_legs: [2,2,4,4,5,100]
    animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]

    Creating a RecordBatch from a list of arrays with names and metadata:

    >>> my_metadata={"n_legs": "How many legs does an animal have?"}
    >>> pa.record_batch([n_legs, animals],
    ...                  names=names,
    ...                  metadata = my_metadata)
    pyarrow.RecordBatch
    n_legs: int64
    animals: string
    ----
    n_legs: [2,2,4,4,5,100]
    animals: ["Flamingo","Parrot","Dog","Horse","Brittle stars","Centipede"]
    >>> pa.record_batch([n_legs, animals],
    ...                  names=names,
    ...                  metadata = my_metadata).schema
    n_legs: int64
    animals: string
    -- schema metadata --
    n_legs: 'How many legs does an animal have?'

    Creating a RecordBatch from a pandas DataFrame:

    >>> import pandas as pd
    >>> df = pd.DataFrame({'year': [2020, 2022, 2021, 2022],
    ...                    'month': [3, 5, 7, 9],
    ...                    'day': [1, 5, 9, 13],
    ...                    'n_legs': [2, 4, 5, 100],
    ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
    >>> pa.record_batch(df)
    pyarrow.RecordBatch
    year: int64
    month: int64
    day: int64
    n_legs: int64
    animals: string
    ----
    year: [2020,2022,2021,2022]
    month: [3,5,7,9]
    day: [1,5,9,13]
    n_legs: [2,4,5,100]
    animals: ["Flamingo","Horse","Brittle stars","Centipede"]

    >>> pa.record_batch(df).to_pandas()
       year  month  day  n_legs        animals
    0  2020      3    1       2       Flamingo
    1  2022      5    5       4          Horse
    2  2021      7    9       5  Brittle stars
    3  2022      9   13     100      Centipede

    Creating a RecordBatch from a pandas DataFrame with schema:

    >>> my_schema = pa.schema([
    ...     pa.field('n_legs', pa.int64()),
    ...     pa.field('animals', pa.string())],
    ...     metadata={"n_legs": "Number of legs per animal"})
    >>> pa.record_batch(df, my_schema).schema
    n_legs: int64
    animals: string
    -- schema metadata --
    n_legs: 'Number of legs per animal'
    pandas: ...
    >>> pa.record_batch(df, my_schema).to_pandas()
       n_legs        animals
    0       2       Flamingo
    1       4          Horse
    2       5  Brittle stars
    3     100      Centipede
    """
    # accept schema as first argument for backwards compatibility / usability
    if isinstance(names, Schema) and schema is None:
        schema = names
        names = None

    if isinstance(data, (list, tuple)):
        return RecordBatch.from_arrays(data, names=names, schema=schema,
                                       metadata=metadata)
    elif isinstance(data, dict):
        if names is not None:
            raise ValueError(
                "The 'names' argument is not valid when passing a dictionary")
        return RecordBatch.from_pydict(data, schema=schema, metadata=metadata)
    elif hasattr(data, "__arrow_c_device_array__"):
        if schema is not None:
            requested_schema = schema.__arrow_c_schema__()
        else:
            requested_schema = None
        schema_capsule, array_capsule = data.__arrow_c_device_array__(requested_schema)
        batch = RecordBatch._import_from_c_device_capsule(schema_capsule, array_capsule)
        if schema is not None and batch.schema != schema:
            # __arrow_c_device_array__ coerces schema with best effort, so we might
            # need to cast it if the producer wasn't able to cast to exact schema.
            batch = batch.cast(schema)
        return batch
    elif hasattr(data, "__arrow_c_array__"):
        if schema is not None:
            requested_schema = schema.__arrow_c_schema__()
        else:
            requested_schema = None
        schema_capsule, array_capsule = data.__arrow_c_array__(requested_schema)
        batch = RecordBatch._import_from_c_capsule(schema_capsule, array_capsule)
        if schema is not None and batch.schema != schema:
            # __arrow_c_array__ coerces schema with best effort, so we might
            # need to cast it if the producer wasn't able to cast to exact schema.
            batch = batch.cast(schema)
        return batch

    elif _pandas_api.is_data_frame(data):
        return RecordBatch.from_pandas(data, schema=schema)

    else:
        raise TypeError("Expected pandas DataFrame or list of arrays")


def table(data, names=None, schema=None, metadata=None, nthreads=None):
    """
    Create a pyarrow.Table from a Python data structure or sequence of arrays.

    Parameters
    ----------
    data : dict, list, pandas.DataFrame, Arrow-compatible table
        A mapping of strings to Arrays or Python lists, a list of arrays or
        chunked arrays, a pandas DataFame, or any tabular object implementing
        the Arrow PyCapsule Protocol (has an ``__arrow_c_array__``,
        ``__arrow_c_device_array__`` or ``__arrow_c_stream__`` method).
    names : list, default None
        Column names if list of arrays passed as data. Mutually exclusive with
        'schema' argument.
    schema : Schema, default None
        The expected schema of the Arrow Table. If not passed, will be inferred
        from the data. Mutually exclusive with 'names' argument.
        If passed, the output will have exactly this schema (raising an error
        when columns are not found in the data and ignoring additional data not
        specified in the schema, when data is a dict or DataFrame).
    metadata : dict or Mapping, default None
        Optional metadata for the schema (if schema not passed).
    nthreads : int, default None
        For pandas.DataFrame inputs: if greater than 1, convert columns to
        Arrow in parallel using indicated number of threads. By default,
        this follows :func:`pyarrow.cpu_count` (may use up to system CPU count
        threads).

    Returns
    -------
    Table

    See Also
    --------
    Table.from_arrays, Table.from_pandas, Table.from_pydict

    Examples
    --------
    >>> import pyarrow as pa
    >>> n_legs = pa.array([2, 4, 5, 100])
    >>> animals = pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
    >>> names = ["n_legs", "animals"]

    Construct a Table from a python dictionary:

    >>> pa.table({"n_legs": n_legs, "animals": animals})
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

    Construct a Table from arrays:

    >>> pa.table([n_legs, animals], names=names)
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

    Construct a Table from arrays with metadata:

    >>> my_metadata={"n_legs": "Number of legs per animal"}
    >>> pa.table([n_legs, animals], names=names, metadata = my_metadata).schema
    n_legs: int64
    animals: string
    -- schema metadata --
    n_legs: 'Number of legs per animal'

    Construct a Table from pandas DataFrame:

    >>> import pandas as pd
    >>> df = pd.DataFrame({'year': [2020, 2022, 2019, 2021],
    ...                    'n_legs': [2, 4, 5, 100],
    ...                    'animals': ["Flamingo", "Horse", "Brittle stars", "Centipede"]})
    >>> pa.table(df)
    pyarrow.Table
    year: int64
    n_legs: int64
    animals: string
    ----
    year: [[2020,2022,2019,2021]]
    n_legs: [[2,4,5,100]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"]]

    Construct a Table from pandas DataFrame with pyarrow schema:

    >>> my_schema = pa.schema([
    ...     pa.field('n_legs', pa.int64()),
    ...     pa.field('animals', pa.string())],
    ...     metadata={"n_legs": "Number of legs per animal"})
    >>> pa.table(df, my_schema).schema
    n_legs: int64
    animals: string
    -- schema metadata --
    n_legs: 'Number of legs per animal'
    pandas: '{"index_columns": [], "column_indexes": [{"name": null, ...

    Construct a Table from chunked arrays:

    >>> n_legs = pa.chunked_array([[2, 2, 4], [4, 5, 100]])
    >>> animals = pa.chunked_array([["Flamingo", "Parrot", "Dog"], ["Horse", "Brittle stars", "Centipede"]])
    >>> table = pa.table([n_legs, animals], names=names)
    >>> table
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,2,4],[4,5,100]]
    animals: [["Flamingo","Parrot","Dog"],["Horse","Brittle stars","Centipede"]]
    """
    # accept schema as first argument for backwards compatibility / usability
    if isinstance(names, Schema) and schema is None:
        schema = names
        names = None

    if isinstance(data, (list, tuple)):
        return Table.from_arrays(data, names=names, schema=schema,
                                 metadata=metadata)
    elif isinstance(data, dict):
        if names is not None:
            raise ValueError(
                "The 'names' argument is not valid when passing a dictionary")
        return Table.from_pydict(data, schema=schema, metadata=metadata)
    elif _pandas_api.is_data_frame(data):
        if names is not None or metadata is not None:
            raise ValueError(
                "The 'names' and 'metadata' arguments are not valid when "
                "passing a pandas DataFrame")
        return Table.from_pandas(data, schema=schema, nthreads=nthreads)
    elif hasattr(data, "__arrow_c_stream__"):
        if names is not None or metadata is not None:
            raise ValueError(
                "The 'names' and 'metadata' arguments are not valid when "
                "using Arrow PyCapsule Interface")
        if schema is not None:
            requested = schema.__arrow_c_schema__()
        else:
            requested = None
        capsule = data.__arrow_c_stream__(requested)
        reader = RecordBatchReader._import_from_c_capsule(capsule)
        table = reader.read_all()
        if schema is not None and table.schema != schema:
            # __arrow_c_array__ coerces schema with best effort, so we might
            # need to cast it if the producer wasn't able to cast to exact schema.
            table = table.cast(schema)
        return table
    elif hasattr(data, "__arrow_c_array__") or hasattr(data, "__arrow_c_device_array__"):
        if names is not None or metadata is not None:
            raise ValueError(
                "The 'names' and 'metadata' arguments are not valid when "
                "using Arrow PyCapsule Interface")
        batch = record_batch(data, schema)
        return Table.from_batches([batch])
    else:
        raise TypeError(
            "Expected pandas DataFrame, python dictionary or list of arrays")


def concat_tables(tables, MemoryPool memory_pool=None, str promote_options="none", **kwargs):
    """
    Concatenate pyarrow.Table objects.

    If promote_options="none", a zero-copy concatenation will be performed. The schemas
    of all the Tables must be the same (except the metadata), otherwise an
    exception will be raised. The result Table will share the metadata with the
    first table.

    If promote_options="default", any null type arrays will be casted to the type of other
    arrays in the column of the same name. If a table is missing a particular
    field, null values of the appropriate type will be generated to take the
    place of the missing field. The new schema will share the metadata with the
    first table. Each field in the new schema will share the metadata with the
    first table which has the field defined. Note that type promotions may
    involve additional allocations on the given ``memory_pool``.

    If promote_options="permissive", the behavior of default plus types will be promoted
    to the common denominator that fits all the fields.

    Parameters
    ----------
    tables : iterable of pyarrow.Table objects
        Pyarrow tables to concatenate into a single Table.
    memory_pool : MemoryPool, default None
        For memory allocations, if required, otherwise use default pool.
    promote_options : str, default none
        Accepts strings "none", "default" and "permissive".
    **kwargs : dict, optional

    Examples
    --------
    >>> import pyarrow as pa
    >>> t1 = pa.table([
    ...     pa.array([2, 4, 5, 100]),
    ...     pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
    ...     ], names=['n_legs', 'animals'])
    >>> t2 = pa.table([
    ...     pa.array([2, 4]),
    ...     pa.array(["Parrot", "Dog"])
    ...     ], names=['n_legs', 'animals'])
    >>> pa.concat_tables([t1,t2])
    pyarrow.Table
    n_legs: int64
    animals: string
    ----
    n_legs: [[2,4,5,100],[2,4]]
    animals: [["Flamingo","Horse","Brittle stars","Centipede"],["Parrot","Dog"]]

    """
    cdef:
        vector[shared_ptr[CTable]] c_tables
        shared_ptr[CTable] c_result_table
        CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)
        Table table
        CConcatenateTablesOptions options = (
            CConcatenateTablesOptions.Defaults())

    if "promote" in kwargs:
        warnings.warn(
            "promote has been superseded by promote_options='default'.",
            FutureWarning, stacklevel=2)
        if kwargs['promote'] is True:
            promote_options = "default"

    for table in tables:
        c_tables.push_back(table.sp_table)

    options.field_merge_options = _parse_field_merge_options(
        "default" if promote_options == "none" else promote_options
    )

    options.unify_schemas = promote_options != "none"
    with nogil:
        c_result_table = GetResultValue(
            ConcatenateTables(c_tables, options, pool))

    return pyarrow_wrap_table(c_result_table)


def concat_batches(recordbatches, MemoryPool memory_pool=None):
    """
    Concatenate pyarrow.RecordBatch objects.

    All recordbatches must share the same Schema,
    the operation implies a copy of the data to merge
    the arrays of the different RecordBatches.

    Parameters
    ----------
    recordbatches : iterable of pyarrow.RecordBatch objects
        Pyarrow record batches to concatenate into a single RecordBatch.
    memory_pool : MemoryPool, default None
        For memory allocations, if required, otherwise use default pool.

    Examples
    --------
    >>> import pyarrow as pa
    >>> t1 = pa.record_batch([
    ...     pa.array([2, 4, 5, 100]),
    ...     pa.array(["Flamingo", "Horse", "Brittle stars", "Centipede"])
    ...     ], names=['n_legs', 'animals'])
    >>> t2 = pa.record_batch([
    ...     pa.array([2, 4]),
    ...     pa.array(["Parrot", "Dog"])
    ...     ], names=['n_legs', 'animals'])
    >>> pa.concat_batches([t1,t2])
    pyarrow.RecordBatch
    n_legs: int64
    animals: string
    ----
    n_legs: [2,4,5,100,2,4]
    animals: ["Flamingo","Horse","Brittle stars","Centipede","Parrot","Dog"]

    """
    cdef:
        vector[shared_ptr[CRecordBatch]] c_recordbatches
        shared_ptr[CRecordBatch] c_result_recordbatch
        RecordBatch recordbatch
        CMemoryPool* pool = maybe_unbox_memory_pool(memory_pool)

    for recordbatch in recordbatches:
        c_recordbatches.push_back(recordbatch.sp_batch)

    with nogil:
        c_result_recordbatch = GetResultValue(
            ConcatenateRecordBatches(c_recordbatches, pool))

    return pyarrow_wrap_batch(c_result_recordbatch)


def _from_pydict(cls, mapping, schema, metadata):
    """
    Construct a Table/RecordBatch from Arrow arrays or columns.

    Parameters
    ----------
    cls : Class Table/RecordBatch
    mapping : dict or Mapping
        A mapping of strings to Arrays or Python lists.
    schema : Schema, default None
        If not passed, will be inferred from the Mapping values.
    metadata : dict or Mapping, default None
        Optional metadata for the schema (if inferred).

    Returns
    -------
    Table/RecordBatch
    """

    arrays = []
    if schema is None:
        names = []
        for k, v in mapping.items():
            names.append(k)
            arrays.append(asarray(v))
        return cls.from_arrays(arrays, names, metadata=metadata)
    elif isinstance(schema, Schema):
        for field in schema:
            try:
                v = mapping[field.name]
            except KeyError:
                try:
                    v = mapping[tobytes(field.name)]
                except KeyError:
                    present = mapping.keys()
                    missing = [n for n in schema.names if n not in present]
                    raise KeyError(
                        "The passed mapping doesn't contain the "
                        "following field(s) of the schema: {}".
                        format(', '.join(missing))
                    )
            arrays.append(asarray(v, type=field.type))
        # Will raise if metadata is not None
        return cls.from_arrays(arrays, schema=schema, metadata=metadata)
    else:
        raise TypeError('Schema must be an instance of pyarrow.Schema')


def _from_pylist(cls, mapping, schema, metadata):
    """
    Construct a Table/RecordBatch from list of rows / dictionaries.

    Parameters
    ----------
    cls : Class Table/RecordBatch
    mapping : list of dicts of rows
        A mapping of strings to row values.
    schema : Schema, default None
        If not passed, will be inferred from the first row of the
        mapping values.
    metadata : dict or Mapping, default None
        Optional metadata for the schema (if inferred).

    Returns
    -------
    Table/RecordBatch
    """

    arrays = []
    if schema is None:
        names = []
        if mapping:
            names = list(mapping[0].keys())
        for n in names:
            v = [row[n] if n in row else None for row in mapping]
            arrays.append(v)
        return cls.from_arrays(arrays, names, metadata=metadata)
    else:
        if isinstance(schema, Schema):
            for n in schema.names:
                v = [row[n] if n in row else None for row in mapping]
                arrays.append(v)
            # Will raise if metadata is not None
            return cls.from_arrays(arrays, schema=schema, metadata=metadata)
        else:
            raise TypeError('Schema must be an instance of pyarrow.Schema')


class TableGroupBy:
    """
    A grouping of columns in a table on which to perform aggregations.

    Parameters
    ----------
    table : pyarrow.Table
        Input table to execute the aggregation on.
    keys : str or list[str]
        Name of the grouped columns.
    use_threads : bool, default True
        Whether to use multithreading or not. When set to True (the default),
        no stable ordering of the output is guaranteed.

    Examples
    --------
    >>> import pyarrow as pa
    >>> t = pa.table([
    ...       pa.array(["a", "a", "b", "b", "c"]),
    ...       pa.array([1, 2, 3, 4, 5]),
    ... ], names=["keys", "values"])

    Grouping of columns:

    >>> pa.TableGroupBy(t,"keys")
    <pyarrow.lib.TableGroupBy object at ...>

    Perform aggregations:

    >>> pa.TableGroupBy(t,"keys").aggregate([("values", "sum")])
    pyarrow.Table
    keys: string
    values_sum: int64
    ----
    keys: [["a","b","c"]]
    values_sum: [[3,7,5]]
    """

    def __init__(self, table, keys, use_threads=True):
        if isinstance(keys, str):
            keys = [keys]

        self._table = table
        self.keys = keys
        self._use_threads = use_threads

    def aggregate(self, aggregations):
        """
        Perform an aggregation over the grouped columns of the table.

        Parameters
        ----------
        aggregations : list[tuple(str, str)] or \
list[tuple(str, str, FunctionOptions)]
            List of tuples, where each tuple is one aggregation specification
            and consists of: aggregation column name followed
            by function name and optionally aggregation function option.
            Pass empty list to get a single row for each group.
            The column name can be a string, an empty list or a list of
            column names, for unary, nullary and n-ary aggregation functions
            respectively.

            For the list of function names and respective aggregation
            function options see :ref:`py-grouped-aggrs`.

        Returns
        -------
        Table
            Results of the aggregation functions.

        Examples
        --------
        >>> import pyarrow as pa
        >>> t = pa.table([
        ...       pa.array(["a", "a", "b", "b", "c"]),
        ...       pa.array([1, 2, 3, 4, 5]),
        ... ], names=["keys", "values"])

        Sum the column "values" over the grouped column "keys":

        >>> t.group_by("keys").aggregate([("values", "sum")])
        pyarrow.Table
        keys: string
        values_sum: int64
        ----
        keys: [["a","b","c"]]
        values_sum: [[3,7,5]]

        Count the rows over the grouped column "keys":

        >>> t.group_by("keys").aggregate([([], "count_all")])
        pyarrow.Table
        keys: string
        count_all: int64
        ----
        keys: [["a","b","c"]]
        count_all: [[2,2,1]]

        Do multiple aggregations:

        >>> t.group_by("keys").aggregate([
        ...    ("values", "sum"),
        ...    ("keys", "count")
        ... ])
        pyarrow.Table
        keys: string
        values_sum: int64
        keys_count: int64
        ----
        keys: [["a","b","c"]]
        values_sum: [[3,7,5]]
        keys_count: [[2,2,1]]

        Count the number of non-null values for column "values"
        over the grouped column "keys":

        >>> import pyarrow.compute as pc
        >>> t.group_by(["keys"]).aggregate([
        ...    ("values", "count", pc.CountOptions(mode="only_valid"))
        ... ])
        pyarrow.Table
        keys: string
        values_count: int64
        ----
        keys: [["a","b","c"]]
        values_count: [[2,2,1]]

        Get a single row for each group in column "keys":

        >>> t.group_by("keys").aggregate([])
        pyarrow.Table
        keys: string
        ----
        keys: [["a","b","c"]]
        """
        group_by_aggrs = []
        for aggr in aggregations:
            # Set opt to None if not specified
            if len(aggr) == 2:
                target, func = aggr
                opt = None
            else:
                target, func, opt = aggr
            # Ensure target is a list
            if not isinstance(target, (list, tuple)):
                target = [target]
            # Ensure aggregate function is hash_ if needed
            if len(self.keys) > 0 and not func.startswith("hash_"):
                func = "hash_" + func
            if len(self.keys) == 0 and func.startswith("hash_"):
                func = func[5:]
            # Determine output field name
            func_nohash = func if not func.startswith("hash_") else func[5:]
            if len(target) == 0:
                aggr_name = func_nohash
            else:
                aggr_name = "_".join(target) + "_" + func_nohash
            group_by_aggrs.append((target, func, opt, aggr_name))

        return _pac()._group_by(
            self._table, group_by_aggrs, self.keys, use_threads=self._use_threads
        )
