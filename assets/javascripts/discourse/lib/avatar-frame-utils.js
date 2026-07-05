export function isAnimationsDisabled(user) {
  const val = user?.custom_fields?.disable_avatar_animations;
  return val === "true" || val === true;
}
