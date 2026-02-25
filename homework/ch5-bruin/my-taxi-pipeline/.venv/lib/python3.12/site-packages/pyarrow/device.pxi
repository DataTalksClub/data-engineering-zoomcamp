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

# cython: profile=False
# distutils: language = c++
# cython: embedsignature = True


cpdef enum DeviceAllocationType:
    CPU = <char> CDeviceAllocationType_kCPU
    CUDA = <char> CDeviceAllocationType_kCUDA
    CUDA_HOST = <char> CDeviceAllocationType_kCUDA_HOST
    OPENCL = <char> CDeviceAllocationType_kOPENCL
    VULKAN = <char> CDeviceAllocationType_kVULKAN
    METAL = <char> CDeviceAllocationType_kMETAL
    VPI = <char> CDeviceAllocationType_kVPI
    ROCM = <char> CDeviceAllocationType_kROCM
    ROCM_HOST = <char> CDeviceAllocationType_kROCM_HOST
    EXT_DEV = <char> CDeviceAllocationType_kEXT_DEV
    CUDA_MANAGED = <char> CDeviceAllocationType_kCUDA_MANAGED
    ONEAPI = <char> CDeviceAllocationType_kONEAPI
    WEBGPU = <char> CDeviceAllocationType_kWEBGPU
    HEXAGON = <char> CDeviceAllocationType_kHEXAGON


cdef object _wrap_device_allocation_type(CDeviceAllocationType device_type):
    return DeviceAllocationType(<char> device_type)


cdef class Device(_Weakrefable):
    """
    Abstract interface for hardware devices

    This object represents a device with access to some memory spaces.
    When handling a Buffer or raw memory address, it allows deciding in which
    context the raw memory address should be interpreted
    (e.g. CPU-accessible memory, or embedded memory on some particular GPU).
    """

    def __init__(self):
        raise TypeError("Do not call Device's constructor directly, "
                        "use the device attribute of the MemoryManager instead.")

    cdef void init(self, const shared_ptr[CDevice]& device):
        self.device = device

    @staticmethod
    cdef wrap(const shared_ptr[CDevice]& device):
        cdef Device self = Device.__new__(Device)
        self.init(device)
        return self

    cdef inline shared_ptr[CDevice] unwrap(self) nogil:
        return self.device

    def __eq__(self, other):
        if not isinstance(other, Device):
            return False
        return self.device.get().Equals(deref((<Device>other).device.get()))

    def __repr__(self):
        return f"<pyarrow.Device: {frombytes(self.device.get().ToString())}>"

    @property
    def type_name(self):
        """
        A shorthand for this device's type.
        """
        return frombytes(self.device.get().type_name())

    @property
    def device_id(self):
        """
        A device ID to identify this device if there are multiple of this type.

        If there is no "device_id" equivalent (such as for the main CPU device on
        non-numa systems) returns -1.
        """
        return self.device.get().device_id()

    @property
    def is_cpu(self):
        """
        Whether this device is the main CPU device.

        This shorthand method is very useful when deciding whether a memory address
        is CPU-accessible.
        """
        return self.device.get().is_cpu()

    @property
    def device_type(self):
        """
        Return the DeviceAllocationType of this device.
        """
        return _wrap_device_allocation_type(self.device.get().device_type())


cdef class MemoryManager(_Weakrefable):
    """
    An object that provides memory management primitives.

    A MemoryManager is always tied to a particular Device instance.
    It can also have additional parameters (such as a MemoryPool to
    allocate CPU memory).

    """

    def __init__(self):
        raise TypeError("Do not call MemoryManager's constructor directly, "
                        "use pyarrow.default_cpu_memory_manager() instead.")

    cdef void init(self, const shared_ptr[CMemoryManager]& mm):
        self.memory_manager = mm

    @staticmethod
    cdef wrap(const shared_ptr[CMemoryManager]& mm):
        cdef MemoryManager self = MemoryManager.__new__(MemoryManager)
        self.init(mm)
        return self

    cdef inline shared_ptr[CMemoryManager] unwrap(self) nogil:
        return self.memory_manager

    def __repr__(self):
        device_str = frombytes(self.memory_manager.get().device().get().ToString())
        return f"<pyarrow.MemoryManager device: {device_str}>"

    @property
    def device(self):
        """
        The device this MemoryManager is tied to.
        """
        return Device.wrap(self.memory_manager.get().device())

    @property
    def is_cpu(self):
        """
        Whether this MemoryManager is tied to the main CPU device.

        This shorthand method is very useful when deciding whether a memory
        address is CPU-accessible.
        """
        return self.memory_manager.get().is_cpu()


def default_cpu_memory_manager():
    """
    Return the default CPU MemoryManager instance.

    The returned singleton instance uses the default MemoryPool.
    """
    return MemoryManager.wrap(c_default_cpu_memory_manager())
