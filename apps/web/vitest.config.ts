// 테스트 도구(vitest) 설정. "@/..." 를 src/ 로 읽게 알려 준다(tsconfig.json의 paths와 같은 내용).
import { fileURLToPath } from "node:url";

import { defineConfig } from "vitest/config";

export default defineConfig({
  resolve: {
    alias: { "@": fileURLToPath(new URL("./src", import.meta.url)) },
  },
});
