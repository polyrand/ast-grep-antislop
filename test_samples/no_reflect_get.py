value = getattr(owner, key)
other_value = operator.attrgetter(key)(owner)
