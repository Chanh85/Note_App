/*
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "auth/src/include/firebase/auth/credential.h"

#include "auth/src/common.h"

namespace firebase {
namespace auth {

PhoneAuthCredential::PhoneAuthCredential() : Credential() {}

PhoneAuthCredential::PhoneAuthCredential(void* impl) : Credential(impl) {}

PhoneAuthCredential::PhoneAuthCredential(const PhoneAuthCredential& rhs) {
  *this = rhs;
}

}  // namespace auth
}  // namespace firebase
