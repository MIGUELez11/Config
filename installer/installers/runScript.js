import path, { dirname } from "path";
import { execa } from "execa";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export default function runScript(dir) {
  return execa("sh", [path.join(__dirname, "..", dir)]);
}
