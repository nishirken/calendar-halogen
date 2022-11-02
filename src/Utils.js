export const unsafeInputValue = toJust => toNothing => toEffect => event => {
  if (event.target?.value !== undefined) {
    return toEffect(toJust(event.target.value));
  } else {
    return toEffect(toNothing());
  }
};
