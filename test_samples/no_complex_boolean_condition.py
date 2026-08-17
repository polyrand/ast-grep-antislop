def should_render(contact: Contact) -> bool:
    if contact and not contact.is_active() and (contact.in_group(FAMILY) or contact.in_group(FRIENDS)):
        return True
    return False
