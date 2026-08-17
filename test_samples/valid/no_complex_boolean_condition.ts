function shouldRender(contact: Contact): boolean {
  if (contact) {
    const isInactive = !contact.isActive();
    const isFamilyOrFriends = contact.inGroup(FAMILY) || contact.inGroup(FRIENDS);
    if (isInactive && isFamilyOrFriends) {
      return true;
    }
  }
  return false;
}
