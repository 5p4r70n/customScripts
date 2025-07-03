// save as getCookies.js
const puppeteer = require('puppeteer');

(async () => {
const browser = await puppeteer.launch({
  headless: false,
  args: ['--ozone-platform=wayland']
});
  const page = await browser.newPage();

  const url = 'https://wallpaperflare.com';
  
  await page.setViewport({ width: 1920, height: 1080 });


  // Wait for Enter key
  await new Promise(resolve => {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });
    rl.question('', () => {
      rl.close();
      resolve();
    });
  });


  await page.goto(url, { waitUntil: 'networkidle2' });

  const cookies = await page.cookies();
  cookies.forEach(cookie => {
    console.log(`${cookie.name}=${cookie.value}`);
  });

  await browser.close();
})();
