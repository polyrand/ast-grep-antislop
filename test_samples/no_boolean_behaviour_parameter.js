function render(value, isCompact) {
  if (isCompact) {
    return renderCompact(value);
  }
  return renderFull(value);
}
