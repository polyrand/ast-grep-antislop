function render(value: string, isCompact: boolean): string {
  if (isCompact) {
    return renderCompact(value);
  }
  return renderFull(value);
}
