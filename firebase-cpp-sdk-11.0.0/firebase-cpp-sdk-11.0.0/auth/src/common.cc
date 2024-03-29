/*
 * Copyright 2016 Google LLC
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

#include "auth/src/common.h"

#include <string>

#include "app/src/util.h"

namespace firebase {
namespace auth {

namespace {
static const char kCredentialFutureIdentifier[17] = "Auth-Credentials";
}

const char* const EmailAuthProvider::kProviderId = "password";
const char* const FacebookAuthProvider::kProviderId = "facebook.com";
const char* const GameCenterAuthProvider::kProviderId = "gc.apple.com";
const char* const GitHubAuthProvider::kProviderId = "github.com";
const char* const GoogleAuthProvider::kProviderId = "google.com";
const char* const MicrosoftAuthProvider::kProviderId = "microsoft.com";
const char* const PhoneAuthProvider::kProviderId = "phone";
const char* const PlayGamesAuthProvider::kProviderId = "playgames.google.com";
const char* const TwitterAuthProvider::kProviderId = "twitter.com";
const char* const YahooAuthProvider::kProviderId = "yahoo.com";

ReferenceCountedFutureImpl* GetCredentialFutureImpl() {
  StaticFutureData* future_data = StaticFutureData::GetFutureDataForModule(
      &kCredentialFutureIdentifier, kNumCredentialFunctions);
  if (future_data == nullptr) return nullptr;

  return future_data->api();
}

void CleanupCredentialFutureImpl() {
  StaticFutureData::CleanupFutureDataForModule(&kCredentialFutureIdentifier);
}

void ClearUserInfos(AuthData* auth_data) {
  for (size_t i = 0; i < auth_data->user_infos.size(); ++i) {
    delete auth_data->user_infos[i];
    auth_data->user_infos[i] = nullptr;
  }
  auth_data->user_infos.clear();
}

//
// PhoneAuthOptions
//
PhoneAuthOptions::PhoneAuthOptions() {
  force_resending_token = nullptr;
  timeout_milliseconds = 0;
  ui_parent = nullptr;
}

//
// PhoneAuthProvider
//
void PhoneAuthProvider::Listener::OnCodeSent(
    const std::string& verification_id,
    const ForceResendingToken& force_resending_token) {}

void PhoneAuthProvider::Listener::OnCodeAutoRetrievalTimeOut(
    const std::string& verification_id) {}

///
/// User
///
User::User() { auth_data_ = nullptr; }

bool User::operator==(const User& user) const {
  // This is based on the assumption that there is only one user before
  // Auth rewrite.
  // TODO(AuthRewrite): Must change during Auth Rewrite
  return is_valid() == user.is_valid();
}

bool User::operator!=(const User& user) const { return !(*this == user); }

}  // namespace auth
}  // namespace firebase
