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

cimport pyarrow.includes.libarrow as libarrow
cimport pyarrow.includes.libarrow_python as libarrow_python

from collections import namedtuple
import os


VersionInfo = namedtuple('VersionInfo', ('major', 'minor', 'patch'))

RuntimeInfo = namedtuple('RuntimeInfo',
                         ('simd_level', 'detected_simd_level'))


def runtime_info():
    """
    Get runtime information.

    Returns
    -------
    info : pyarrow.RuntimeInfo
    """
    cdef:
        CRuntimeInfo c_info

    c_info = GetRuntimeInfo()

    return RuntimeInfo(
        simd_level=frombytes(c_info.simd_level),
        detected_simd_level=frombytes(c_info.detected_simd_level))


BuildInfo = namedtuple(
    'BuildInfo',
    ('build_type', 'cpp_build_info'))

CppBuildInfo = namedtuple(
    'CppBuildInfo',
    ('version', 'version_info', 'so_version', 'full_so_version',
     'compiler_id', 'compiler_version', 'compiler_flags',
     'git_id', 'git_description', 'package_kind', 'build_type'))


def _build_info():
    """
    Get PyArrow build information.

    Returns
    -------
    info : pyarrow.BuildInfo
    """
    cdef:
        const libarrow_python.CBuildInfo* c_info
        const libarrow.CCppBuildInfo* c_cpp_info

    c_info = &libarrow_python.GetBuildInfo()
    c_cpp_info = &libarrow.GetCppBuildInfo()

    cpp_build_info = CppBuildInfo(version=frombytes(c_cpp_info.version_string),
                                  version_info=VersionInfo(c_cpp_info.version_major,
                                                           c_cpp_info.version_minor,
                                                           c_cpp_info.version_patch),
                                  so_version=frombytes(c_cpp_info.so_version),
                                  full_so_version=frombytes(c_cpp_info.full_so_version),
                                  compiler_id=frombytes(c_cpp_info.compiler_id),
                                  compiler_version=frombytes(
                                      c_cpp_info.compiler_version),
                                  compiler_flags=frombytes(c_cpp_info.compiler_flags),
                                  git_id=frombytes(c_cpp_info.git_id),
                                  git_description=frombytes(c_cpp_info.git_description),
                                  package_kind=frombytes(c_cpp_info.package_kind),
                                  build_type=frombytes(c_cpp_info.build_type).lower(),
                                  )

    return BuildInfo(build_type=c_info.build_type.decode('utf-8').lower(),
                     cpp_build_info=cpp_build_info)


build_info = _build_info()
cpp_build_info = build_info.cpp_build_info
cpp_version = build_info.cpp_build_info.version
cpp_version_info = build_info.cpp_build_info.version_info


def set_timezone_db_path(path):
    """
    Configure the path to text timezone database on Windows.

    Parameters
    ----------
    path : str
        Path to text timezone database.
    """
    cdef:
        CGlobalOptions options

    if path is not None:
        options.timezone_db_path = <c_string>tobytes(path)

    check_status(Initialize(options))
