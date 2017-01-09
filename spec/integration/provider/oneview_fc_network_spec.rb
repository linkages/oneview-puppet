################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_fc_network).provider(:c7000)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_fc_network).new(
      name: 'fc',
      ensure: 'present',
      data:
          {
            'name' => 'OneViewSDK Test FC Network',
            'connectionTemplateUri'   => nil,
            'autoLoginRedistribution' => true,
            'fabricType'              => 'FabricAttach'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider oneview_fc_network' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fc_network).provider(:c7000)
  end

  context 'given the minimum parameters' do
    before(:each) do
      provider.exists?
    end
    it 'exists? should return false at first' do
      expect(provider.exists?).not_to be
    end

    it 'found should return false at first' do
      expect { provider.found }.to raise_error(/No FCNetwork with the specified data were found on the Oneview Appliance/)
    end

    it 'should create a new network' do
      expect(provider.create).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fc_network).new(
        name: 'fc',
        ensure: 'present',
        data:
            {
              'name' => 'OneViewSDK Test FC Network'
            }
      )
    end
    before(:each) do
      provider.exists?
    end
    it 'exists? should find a network' do
      expect(provider.exists?).to be
    end

    it 'should run destroy' do
      expect(provider.destroy).to be
    end
  end
end
