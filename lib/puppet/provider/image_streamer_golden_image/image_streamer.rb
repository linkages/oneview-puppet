################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

require_relative '../image_streamer_resource'

Puppet::Type::Image_streamer_golden_image.provide :image_streamer, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer Golden Image using the Image Streamer API'

  confine feature: :oneview

  mk_resource_methods

  def data_parse
    @golden_image_path = @data.delete('golden_image_path')
  end

  def create
    timeout = @data.delete('timeout') || OneviewSDK::Rest::READ_TIMEOUT
    return super unless @golden_image_path && !@item.retrieve!
    @resource_type.add(@client, @golden_image_path, @data, timeout)
  end

  def download_details_archive
    validation_for_download('details_archive_path')
    get_single_resource_instance.download_details_archive(@path)
  end

  def download
    validation_for_download('golden_image_download_path')
    get_single_resource_instance.download(@path)
  end

  def validation_for_download(path_type)
    @path = @data.delete(path_type)
    force = @data.delete('force')
    raise "File #{@path} already exists." if File.exist?(@path) && !force
  end
end
