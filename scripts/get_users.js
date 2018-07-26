const Nightmare = require('nightmare')
require('nightmare-download-manager')(Nightmare);

const nightmare = Nightmare({
  show: true
})

nightmare.on('download', function(state, downloadItem){
  if(state == 'started'){
    nightmare.emit('download', './AV_assets.xml', downloadItem);
  }
});

nightmare
  .viewport(1920, 1080)
  .downloadManager()
  .goto('https://qualysguard.qualys.eu/qglogin/index.html')
  .wait('#myform_UserLogin')
  .type('#myform_UserLogin', 'identifiant')
  .type('#myform_UserPasswd', 'motdepasse')
  .click('input[value="Log In"]')
  .wait('#ext-gen15')
  .goto('https://qualysguard.qualys.eu/portal-front/module/asset/#tab=assets.asset-list-v2-asset-container')
  .wait('.x-btn-text.list-config-btn')
  .click('.x-btn-text.list-config-btn')
  .wait('.x-menu-list-item')
  .click('.x-menu-list-item')
  .wait('.qx-icon-report-format-xml')
  .click('.qx-icon-report-format-xml')
  .wait(2000)
  .wait('.x-btn.q-btn-blue-dark.x-btn-noicon')
  .click('.x-btn.q-btn-blue-dark.x-btn-noicon')
  .waitDownloadsComplete()
  .click('#ext-gen31')
  .wait(2000)
  .end()
  .then()
  .catch(error => {
    console.error('Search failed:', error)
  })
