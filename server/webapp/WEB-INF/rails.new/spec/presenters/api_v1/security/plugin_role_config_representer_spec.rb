##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

require 'spec_helper'

describe ApiV1::Security::PluginRoleConfigRepresenter do

  it 'should serialize to json' do
    role = PluginRoleConfig.new('blackbird', 'ldap', ConfigurationPropertyMother.create('foo', false, 'bar'))
    actual_json = ApiV1::Security::RoleConfigRepresenter.new(role).to_hash(url_builder: UrlBuilder.new)

    expect(actual_json).to have_links(:doc, :self, :find)

    expect(actual_json).to have_link(:doc).with_url('https://api.gocd.io/#roles')
    expect(actual_json).to have_link(:self).with_url('http://test.host/api/admin/security/roles/blackbird')
    expect(actual_json).to have_link(:find).with_url('http://test.host/api/admin/security/roles/:role_name')

    actual_json.delete(:_links)

    expect(actual_json).to eq(name: 'blackbird', type: 'plugin', attributes: {auth_config_id: 'ldap', properties: [{key: 'foo', value: 'bar'}]})
  end

  it 'should deserialize from json' do
    new_role = ApiV1::Security::RoleConfigRepresenter.new(PluginRoleConfig.new).from_hash(name: 'blackbird', type: 'plugin', attributes: {auth_config_id: 'ldap', properties: [{key: 'foo', value: 'bar'}]})

    expect(new_role.name.to_s).to eq('blackbird')
    expect(new_role.auth_config_id).to eq('ldap')
    expect(new_role).to be_instance_of(PluginRoleConfig)
    expect(new_role.getConfigurationAsMap(true)).to eq({'foo' => 'bar'})
  end
end