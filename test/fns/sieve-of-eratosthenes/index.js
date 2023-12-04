module.exports = (req, res) => {
  // Function to generate primes
  const generatePrimes = () => {
    const max = 10000;
    let sieve = [],
      i,
      j,
      primes = [];
    for (i = 2; i <= max; ++i) {
      if (!sieve[i]) {
        primes.push(i);
        for (j = i << 1; j <= max; j += i) {
          sieve[j] = true;
        }
      }
    }

    response = "Found " + primes.length + " primes under " + max;

    console.log(response);

    res.send(response + "\n");
  };

  // Add a sleep of 5 seconds
  setTimeout(generatePrimes, 5000);
};
