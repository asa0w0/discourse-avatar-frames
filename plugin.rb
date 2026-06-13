# name: discourse-avatar-frames
# about: Allows users to select animated CSS avatar frames
# version: 0.1
# authors: Antigravity
# url: https://github.com/discourse/discourse-avatar-frames

enabled_site_setting :avatar_frames_enabled

register_asset "stylesheets/common/avatar-frames.scss"

after_initialize do
  User.register_custom_field_type('avatar_frame', :string)
  register_editable_user_custom_field(:avatar_frame)

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
  add_to_serializer(:post, :user_avatar_frame, false) do
    object.user&.custom_fields&.[]('avatar_frame')
  end
end
