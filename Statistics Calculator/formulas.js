
document.addEventListener("DOMContentLoaded", function () {
    const methodSelect = document.getElementById("method");
    const methodThings = document.querySelectorAll(".method-things");
    let currentChart = null;

    methodSelect.addEventListener("change", () => {
        const selectedOption = methodSelect.options[methodSelect.selectedIndex];
        const filterValue = selectedOption.getAttribute("data-filter");

        methodThings.forEach(item => {
            const methodCategory = item.getAttribute('data-category');
            if (methodCategory === filterValue) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    });

    methodSelect.dispatchEvent(new Event('change'));

    const generateBtn = document.getElementById("generate-btn");

    generateBtn.addEventListener("click", (btn) => {

        btn.preventDefault();

        const factorial = (num) => {
            let result = 1;
            for (let i = 2; i <= num; i++) {
                result *= i;
            }
            return result;
        };

        const method = methodSelect.value;
        const resultsContainer = document.getElementById("resultsContainer");
        resultsContainer.innerHTML = ""; // Clear old results

        if (currentChart) {
            currentChart.destroy();
            currentChart = null;
        }

        //Poission distribution
        /*const probabilityPoisson = EulersNumber ** -(lambda) * lambda ** numberOfEvents / factorial(numberOfEvents);
        console.log(probabilityPoission);*/
        //end of Values
        /*//IMPORTANT TO POSITION 
        const { jsPDF } = window.jspdf;by Dante Coshiwe
        const doc = new jsPDF();by Dante Coshiwe
        let y = 20;
        doc.setFontSize(20);
        doc.text(`Results for ${method.value}`, 110, y, { align: 'center' });by Dante Coshiwe
        y += 20; by Dante Coshiwe*/

        if (method === "binomialDistribution") {
            const numberOfTrials = parseInt(document.getElementById("numberOfTrials").value);
            const numberOfSuccess = parseInt(document.getElementById("numberOfSuccess").value);
            const probabilityB = parseFloat(document.getElementById("probabilityB").value);
            const probabilityBnot = 1 - probabilityB;

            const binomialCoefficient = (numberOfTrials, numberOfSuccess) => {
                if (numberOfTrials < numberOfSuccess || numberOfTrials < 0) return 0;
                return factorial(numberOfTrials) / (factorial(numberOfSuccess) * factorial(numberOfTrials - numberOfSuccess));
            };

            //ggby Dante Coshiwe
            const specificProbability = binomialCoefficient(numberOfTrials, numberOfSuccess) *
                Math.pow(probabilityB, numberOfSuccess) *
                Math.pow(probabilityBnot, numberOfTrials - numberOfSuccess);

            let data = [];
            for (let i = 0; i <= numberOfTrials; i++) {
                let binomialResult = binomialCoefficient(numberOfTrials, i) * (Math.pow(probabilityB, i) * (Math.pow(probabilityBnot, numberOfTrials - i)));
                data.push({ x: i, y: binomialResult });
            }
            //ggby Dante Coshiwe
            const ctx = document.getElementById('probabilityChart').getContext('2d');
            const primaryColor = 'hsla(202.82, 76%, 82%, 0.9)';
            const highlightColor = 'hsla(56.46, 100%, 50%, 0.9)';

            currentChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.map(point => point.x),
                    datasets: [{
                        label: 'Probability',
                        data: data.map(point => point.y),
                        backgroundColor: data.map((point, index) =>
                            index === numberOfSuccess ? highlightColor : primaryColor
                        ),
                        borderWidth: 0,
                        borderRadius: 8,
                        barPercentage: 0.8,
                        categoryPercentage: 0.8
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        title: {
                            display: true,
                            text: `Binomial Distribution Visualisation by Dante Coshiwe (n=${numberOfTrials}, p=${probabilityB})`
                        },
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Number of Successes'
                            }
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Probability'
                            }
                        }
                    }
                }
            });


            /*doc.text(`Binomial Probability: ${binomialResult.toFixed(5)}`, 20, y); by Dante Coshiwe
            y += 10; by Dante Coshiwe*/

            resultsContainer.innerHTML = `
                            <div class="result-display">
                                <h4>Binomial Distribution Result:</h4>
                                <p><em>The highlighted bar in the chart shows your specific result</em></p>
                                <p><strong>Parameters:</strong> n=${numberOfTrials}, x=${numberOfSuccess}, p=${probabilityB}</p>
                                <p><strong>P(X = ${numberOfSuccess}):</strong> ${specificProbability.toFixed(8)}</p>
                                <p><strong>Percentage:</strong> ${(specificProbability * 100).toFixed(6)}%</p>
                            </div>
                        `;

        }

        if (method === "poissonDistribution") {
            const lambda = parseFloat(document.getElementById("lambda").value);
            const numberOfEvents = parseInt(document.getElementById("numberOfEvents").value);
            const EulersNumber = 2.71828;
            //ggby Dante Coshiwe
            const specificProbability = Math.pow(Math.E, -lambda) * Math.pow(lambda, numberOfEvents) / factorial(numberOfEvents);

            /*const probabilityPoisson = EulersNumber ** -(lambda) * lambda ** numberOfEvents / factorial(numberOfEvents);
            console.log(probabilityPoission); by Dante Coshiwe*/
            //end of Values
            let poissonResult = Math.pow(EulersNumber, -(lambda)) * Math.pow(lambda, numberOfEvents) / (factorial(numberOfEvents));
            /*doc.text(`Poisson Probability ${poissonResult.toFixed(5)}`, 20, y);
            y += 10; by Dante Coshiwe*/

            let data = [];
            let labels = [];

            for (let j = 0; j <= numberOfEvents; j++) {
                let poissonResult = Math.pow(EulersNumber, -(lambda)) * Math.pow(lambda, j) / (factorial(j));
                data.push({ x: j, y: poissonResult });
            }
            const ctx = document.getElementById('probabilityChart').getContext('2d');

            // Custom smooth, semi-opaque colors
            const primaryColor = 'hsla(202.82, 76%, 82%, 0.9)';
            const highlightColor = 'hsla(56.46, 100%, 50%, 0.9)';

            currentChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.map(point => point.x),
                    datasets: [{
                        label: 'Probability',
                        data: data.map(point => point.y),
                        backgroundColor: data.map((point, index) =>
                            index === numberOfEvents ? highlightColor : primaryColor
                        ),
                        borderWidth: 0, // Removed borders
                        borderRadius: 8, // Rounded corners
                        barPercentage: 0.8,
                        categoryPercentage: 0.8
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        title: {
                            display: true,
                            text: `Poisson Distribution visuals by Dante Coshiwe (λ=${lambda})`
                        },
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Number of Events'
                            }
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Probability'
                            }
                        }
                    }
                }
            });


            resultsContainer.innerHTML = `
                            <div class="result-display">
                                <h4>Poisson Distribution Result:</h4>
                                <p><em>The highlighted bar in the chart shows your specific result</em></p>
                                <p><strong>Parameters:</strong> λ=${lambda}, x=${numberOfEvents}</p>
                                <p><strong>P(X = ${numberOfEvents}):</strong> ${specificProbability.toFixed(8)}</p>
                                <p><strong>Percentage:</strong> ${(specificProbability * 100).toFixed(6)}%</p>
                            </div>
                        `;

        }
        /*btn.preventDefault();by Dante Coshiwe
        doc.save("result.pdf"); by Dante Coshiwe*/
    });
});

