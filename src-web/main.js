const { invoke } = window.__TAURI__.core

const form = document.getElementById('echo-form')
const input = document.getElementById('echo-input')
const resultEl = document.getElementById('echo-result')

form.addEventListener('submit', async (e) => {
  e.preventDefault()
  const message = input.value.trim()
  if (!message) return

  try {
    const response = await invoke('echo', { message })
    resultEl.textContent = response
    resultEl.classList.remove('hidden')
  } catch (error) {
    resultEl.textContent = `Error: ${error}`
    resultEl.classList.remove('hidden')
  }
})
