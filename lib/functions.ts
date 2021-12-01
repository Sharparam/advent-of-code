export function sum(arr: number[]) {
  return arr.reduce((a, e) => a + e, 0);
}

export function* cons<T>(arr: T[], size: number) {
  for (let i = 0; i < arr.length - size + 1; i++) {
    const chunk = arr.slice(i, i + size);
    yield chunk;
  }
}
