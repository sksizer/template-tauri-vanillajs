import { defineConfig } from 'vite'

const port = parseInt(process.env.TAURI_DEV_PORT, 10) || 1420

export default defineConfig({
  clearScreen: false,
  server: {
    port,
    strictPort: true,
    host: 'localhost',
  },
  envPrefix: ['VITE_', 'TAURI_'],
  build: {
    target: ['es2021', 'chrome100', 'safari13'],
    minify: !process.env.TAURI_DEBUG ? 'esbuild' : false,
    sourcemap: !!process.env.TAURI_DEBUG,
  },
})
