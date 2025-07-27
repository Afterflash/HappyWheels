import express from 'express';
import child_process from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { Readable } from 'node:stream';
import { Tail } from 'tail';

// If you change this, you need to change the port in the HappyWheels.as file too.
const port = 8080;

// Set to true to show "trace" logs in the console.
// Note that this will also enable flash warning dialogs and heavily affect performance.
const debug = true;

const baseURL = 'https://totaljerkface.com';

const flashPlayerFile = debug ?
    'flashplayer_32_sa_debug_2.exe' :
    'flashplayer_32_sa.exe';

const __dirname = import.meta.dirname;

const outputFolder = path.join(__dirname, '../output');
const playerFolder = path.join(__dirname, '../player');
const happyWheelsPath = path.join(outputFolder, '/happy_wheels.swf');
const flashPlayerPath = path.join(playerFolder, flashPlayerFile);

const { USERPROFILE, APPDATA } = process.env;

const mmCfgFile = path.join(USERPROFILE, '/mm.cfg');
const flashDir  = path.join(APPDATA,     '/Macromedia/Flash Player');
const logsFile  = path.join(flashDir,    '/Logs/flashlog.txt');
const trustFile = path.join(flashDir,    '/#Security/FlashPlayerTrust/hw.cfg');

if (debug) {
    const mmCfgContent = 'TraceOutputFileEnable=1';

    fs.writeFileSync(mmCfgFile, mmCfgContent.trim());

    const logsFileExists = fs.existsSync(logsFile);

    if (!logsFileExists) {
        fs.mkdirSync(path.dirname(logsFile), { recursive: true });
        fs.writeFileSync(logsFile, '');
    }

    const tail = new Tail(logsFile, {
        useWatchFile: true,
        fsWatchOptions: {
            interval: 100
        },
        follow: true
    });

    tail.on('line', (newLine) => console.log(newLine));
    tail.on('error', (error) => console.error(error));

    process.on('SIGINT', () => {
        tail.unwatch();
        process.exit();
    });
}

fs.mkdirSync(path.dirname(trustFile), { recursive: true });
fs.writeFileSync(trustFile, path.resolve('.'));

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.static(outputFolder));

app.post('/get_level.hw', async (req, res) => {
    const response = await fetch(baseURL + '/get_level.hw', {
        method: 'POST',
        body: new URLSearchParams(req.body)
    });

    res.status(response.status);

    response.headers.forEach((value, key) => res.setHeader(key, value));

    Readable.fromWeb(response.body).pipe(res);
});

app.listen(port, () => {
    console.log('running on port ' + port);
    console.log('the game will open soon...');

    child_process.spawn(flashPlayerPath, [ happyWheelsPath ]);
});