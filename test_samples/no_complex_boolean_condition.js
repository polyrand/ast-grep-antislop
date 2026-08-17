function shouldRender(contact) {
  if (contact && !contact.isActive() && (contact.inGroup(FAMILY) || contact.inGroup(FRIENDS))) {
    return true;
  }
  return false;
}
