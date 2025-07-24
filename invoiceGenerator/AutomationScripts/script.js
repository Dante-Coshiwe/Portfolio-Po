document.addEventListener("DOMContentLoaded", () => {
    const addItemBtn = document.getElementById("add-item");
    const itemContainer = document.getElementById("item-container");
    const generateBtn = document.getElementById("generate-btn");

    addItemBtn.addEventListener("click", () => {
        const itemRow = document.createElement("div");
        itemRow.classList.add("item-row");
        itemRow.innerHTML = `
            <div class="form-group"> 
                <textarea placeholder="Description" required></textarea> 
            </div> 
            <div class="form-group"> 
                <input type="number" class="quantity" placeholder="Quantity" required step="0.01"> 
            </div> 
            <div class="form-group"> 
                <input type="number" class="unitPrice" placeholder="Unit Price" required step="0.01"> 
            </div>
            <div class="form-group">
                <button class"Recourcebutton" type="button" class="remove-item">- Remove item</button>
            </div>
        `;

        const removeBtn = itemRow.querySelector(".remove-item");
        removeBtn.addEventListener("click", () => {
            itemRow.remove();
        });

        itemContainer.appendChild(itemRow);
    });

    generateBtn.addEventListener("click", (e) => {
        e.preventDefault();

        const clientName = document.getElementById("clientName").value;
        const businessName = document.getElementById("businessName").value;
        const email = document.getElementById("email").value;
        const phone = document.getElementById("phone").value;

        if (!clientName || !businessName) {
            alert("Please fill in required fields: Client Name and Business Name");
            return;
        }

        const items = [];
        document.querySelectorAll("#item-container .item-row").forEach(row => {
            const desc = row.querySelector("textarea").value;
            const qty = parseFloat(row.querySelector(".quantity").value) || 0;
            const price = parseFloat(row.querySelector(".unitPrice").value) || 0;
            const total = qty * price;

            if (desc && qty > 0 && price >= 0) {
                items.push({ desc, qty, price, total });
            }
        });

        if (items.length === 0) {
            alert("Please add at least one item to the invoice");
            return;
        }

        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        let y = 20;

        doc.setFontSize(20);
        doc.text('INVOICE', 105, y, { align: 'center' });
        y += 20;

        doc.setFontSize(12);
        doc.text(`From: ${businessName}`, 20, y);
        y += 7;
        if (email) {
            doc.text(`Email: ${email}`, 20, y);
            y += 7;
        }
        if (phone) {
            doc.text(`Phone: ${phone}`, 20, y);
            y += 7;
        }

        y += 10;
        doc.text(`Bill To: ${clientName}`, 20, y);
        y += 15;

        doc.setFontSize(10);
        doc.text('Description', 20, y);
        doc.text('Qty', 120, y);
        doc.text('Unit Price', 140, y);
        doc.text('Total', 170, y);
        y += 5;

        doc.line(20, y, 190, y);
        y += 10;

        let grandTotal = 0;
        items.forEach(item => {
            const lines = doc.splitTextToSize(item.desc, 95);
            const lineHeight = 5;

            doc.text(lines, 20, y);
            doc.text(item.qty.toString(), 120, y);
            doc.text(`R${item.price.toFixed(2)}`, 140, y);
            doc.text(`R${item.total.toFixed(2)}`, 170, y);

            y += Math.max(lines.length * lineHeight, 7);
            grandTotal += item.total;
        });

        y += 10;
        doc.line(20, y, 190, y);
        y += 10;
        doc.setFontSize(14);
        doc.text(`Grand Total: R${grandTotal.toFixed(2)}`, 170, y, { align: 'right' });

        const currentDate = new Date().toLocaleDateString();
        doc.setFontSize(10);
        doc.text(`Date: ${currentDate}`, 20, 280);

        doc.save("invoice.pdf");
    });

    if (addItemBtn) {
        addItemBtn.click();
    }
});
