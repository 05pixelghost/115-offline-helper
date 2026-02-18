const app = document.getElementById('app')
const itemsEl = document.querySelector('#items > div')
const titleEl = document.getElementById('title')

let currentType = 'buy'
let isOpen = false

/* ================= NUI LISTENER ================= */
window.addEventListener('message', (e) => {
  if (e.data.action === 'open') {
    isOpen = true
    app.classList.remove('hidden')

    currentType = e.data.type
    titleEl.textContent =
      currentType === 'buy'
        ? 'FARM NEEDED MARKET'
        : 'FARM PROFIT MARKET'

    renderItems(e.data.items)
  }

  if (e.data.action === 'close') {
    closeUI()
  }
})

/* ================= RENDER ================= */
function renderItems(items) {
  itemsEl.innerHTML = ''

  if (currentType === 'sell' && items.length === 0) {
    itemsEl.innerHTML = `
      <div class="col-span-2 text-center py-20 text-gray-400">
        <p class="text-lg font-semibold">No Item For Sell</p>
      </div>
    `
    return
  }

  items.forEach(item => {
    itemsEl.insertAdjacentHTML('beforeend', `
      <div class="bg-white/5 rounded-xl p-4
                  hover:bg-white/10 transition
                  border border-white/5">

        <!-- IMAGE -->
        <div class="h-[180px] flex items-center justify-center
                    bg-black/30 rounded-lg mb-4">
          <img src="${item.image}"
               class="max-h-[140px]
               drop-shadow-[0_0_25px_rgba(255,255,255,0.25)]">
        </div>

        <!-- INFO -->
        <div class="mb-3">
          <h3 class="font-semibold text-sm text-white">${item.label}</h3>
          <p class="text-xs text-gray-400 mt-1">
            ${
              currentType === 'buy'
                ? `$${item.price} / item`
                : `You own: ${item.amount}`
            }
          </p>
        </div>

        <!-- QTY -->
        <div class="flex items-center gap-2 mb-4">
          <button
            onclick="changeQty('${item.name}', -1)"
            class="w-9 h-9 rounded-lg
                   bg-white/5 hover:bg-white/10
                   text-lg text-white">
            −
          </button>

          <input
            id="qty-${item.name}"
            type="number"
            min="1"
            value="1"
            class="flex-1 text-center
                   bg-black/30 border border-white/10
                   rounded-lg py-2 text-sm text-white
                   focus:outline-none
                   focus:border-emerald-500"
          />

          <button
            onclick="changeQty('${item.name}', 1)"
            class="w-9 h-9 rounded-lg
                   bg-white/5 hover:bg-white/10
                   text-lg text-white">
            +
          </button>
        </div>

        <!-- ACTION -->
        <button
          onclick="actionItem('${item.name}')"
          class="w-full py-2 text-xs font-semibold rounded-lg
          ${
            currentType === 'buy'
              ? 'bg-emerald-500/20 text-emerald-400 hover:bg-emerald-500/30'
              : 'bg-purple-500/20 text-purple-400 hover:bg-purple-500/30'
          }
          transition">
          ${currentType === 'buy' ? 'BUY' : 'SELL'}
        </button>
      </div>
    `)
  })
}

/* ================= QTY CONTROL ================= */
function changeQty(item, delta) {
  const input = document.getElementById(`qty-${item}`)
  if (!input) return

  let value = parseInt(input.value) || 1
  value += delta

  if (value < 1) value = 1
  input.value = value
}

/* ================= ACTION ================= */
function actionItem(item) {
  const input = document.getElementById(`qty-${item}`)
  if (!input) return

  const qty = parseInt(input.value)
  if (!qty || qty < 1) return

  fetch(`https://${GetParentResourceName()}/actionItem`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      item,
      qty,
      type: currentType
    })
  })
}

/* ================= CLOSE ================= */
function closeUI() {
  isOpen = false
  app.classList.add('hidden')

  fetch(`https://${GetParentResourceName()}/close`, {
    method: 'POST'
  })
}

/* ================= ESC ================= */
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && isOpen) {
    closeUI()
  }
})
