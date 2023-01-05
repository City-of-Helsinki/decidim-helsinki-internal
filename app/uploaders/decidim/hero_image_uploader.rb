# frozen_string_literal: true

module Decidim
  # This class deals with uploading hero images to ParticipatoryProcesses.
  # The "hero" image for participatory processes is actually the box image that
  # is shown in the following places:
  # - Full screen image on the processes page when listing ongoing processes
  # - The box image on the processes page when listing past processes
  class HeroImageUploader < RecordImageUploader
    process resize_to_limit: [2200, 520]

    version :card do
      process resize_to_fill: [809, 320]
    end

    version :box do
      process resize_to_fill: [400, 500]
    end
  end
end
