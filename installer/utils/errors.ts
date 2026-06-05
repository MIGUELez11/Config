/**
 * Extract a human-readable message from a thrown value.
 *
 * In strict TypeScript a `catch` binding is `unknown`, so we can't read
 * `error.message` directly. execa rejects with an `ExecaError` that carries a
 * concise `shortMessage`; prefer that, fall back to the standard `message`.
 */
export function errorMessage(error: unknown): string {
  if (error && typeof error === "object") {
    if ("shortMessage" in error && typeof error.shortMessage === "string") {
      return error.shortMessage;
    }
    if ("message" in error && typeof error.message === "string") {
      return error.message;
    }
  }
  return String(error);
}
