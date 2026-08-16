user_id = cast(UserId, value)
# SAFETY: validate_user_id established the branded identifier invariant.
safe_user_id = cast(UserId, validated_value)
