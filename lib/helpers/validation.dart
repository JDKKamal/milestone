String getErrorText(state, key) {
  return state.error != null && state.error[key] != null
      ? state.error[key]
      : null;
}
