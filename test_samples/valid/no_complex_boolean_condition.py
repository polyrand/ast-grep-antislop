def should_render(contact: Contact) -> bool:
    if contact:
        is_inactive = not contact.is_active()
        is_family_or_friends = contact.in_group(FAMILY) or contact.in_group(FRIENDS)
        if is_inactive and is_family_or_friends:
            return True
    return False
