/*
 * SPDX-FileCopyrightText: 2020 Stalwart Labs Ltd <hello@stalw.art>
 *
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SEL
 */

use directory::Permissions;
use jmap_proto::types::collection::Collection;
use utils::map::{bitmap::Bitmap, vec_map::VecMap};

pub mod access_token;
pub mod roles;

#[derive(Debug, Clone, Default)]
pub struct AccessToken {
    pub primary_id: u32,
    pub tenant_id: Option<u32>,
    pub member_of: Vec<u32>,
    pub access_to: VecMap<u32, Bitmap<Collection>>,
    pub name: String,
    pub description: Option<String>,
    pub quota: u64,
    pub permissions: Permissions,
}
