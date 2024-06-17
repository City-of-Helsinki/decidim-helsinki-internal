# frozen_string_literal: true

module Decidim
  # This class deals with uploading hero images to ParticipatoryProcesses.
  # The "hero" image for participatory processes is actually the box image that
  # is shown in the following places:
  # - Full screen image on the processes page when listing ongoing processes
  # - The box image on the processes page when listing past processes
  class HeroImageUploader < RecordImageUploader
    set_variants do
      {
        default: { resize_to_fit: [2200, 520] },
        card: { resize_to_fit: [809, 320] },
        box: { resize_to_fit: [400, 500] }
      }
    end
  end
end
