# name: discourse-avatar-frames
# about: Allows users to select animated CSS avatar frames
# version: 0.1.1
# authors: asa0w0
# url: https://github.com/asa0w0/discourse-avatar-frames

enabled_site_setting :avatar_frames_enabled

register_asset "stylesheets/common/avatar-frames.scss"

after_initialize do
  User.register_custom_field_type('avatar_frame', :string)
  register_editable_user_custom_field(:avatar_frame)

  # Validate frame permissions when user saves their profile
  User.class_eval do
    validate :validate_avatar_frame_permission

    def validate_avatar_frame_permission
      return unless SiteSetting.avatar_frames_enabled

      frame = self.custom_fields['avatar_frame']
      return if frame.blank? || frame == 'none'

      # Only validate if the frame has actually changed
      old_frame = UserCustomField.find_by(user_id: self.id, name: 'avatar_frame')&.value
      return if frame == old_frame

      config_str = SiteSetting.avatar_frames_config || ""
      allowed = false
      frame_found = false

      config_str.split("|").each do |conf|
        parts = conf.split(":")
        next unless parts.length >= 3
        
        id = parts[0].strip
        if id == frame
          frame_found = true
          condition = parts[2..-1].join(":").strip
          
          if condition.start_with?("tl")
            req_level = condition.sub("tl", "").to_i
            allowed = true if self.trust_level >= req_level
          elsif condition.start_with?("group:")
            req_group = condition.sub("group:", "").strip.downcase
            allowed = true if self.groups.any? { |g| g.name.downcase == req_group }
          end
          
          break
        end
      end

      if frame_found && !allowed
        self.errors.add(:base, I18n.t("avatar_frames.errors.no_permission"))
      elsif !frame_found
        self.errors.add(:base, I18n.t("avatar_frames.errors.does_not_exist"))
      end
    end
  end

  # Make it public so the frontend can read it everywhere
  allow_public_user_custom_field(:avatar_frame)

  # Serialize into User (Profile / Card)
  add_to_serializer(:user, :avatar_frame) do
    object.custom_fields['avatar_frame']
  end

  add_to_serializer(:user_card, :avatar_frame) do
    object.custom_fields['avatar_frame']
  end

  # Serialize into Post (Topic stream)
  add_to_serializer(:post, :user_avatar_frame) do
    object.user&.custom_fields&.[]('avatar_frame')
  end
end
