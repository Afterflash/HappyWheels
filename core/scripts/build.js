import fs from 'node:fs';
import path from 'node:path';

const __dirname = import.meta.dirname;
const srcFolder = path.join(__dirname, '../../src');
console.log('Source folder:', srcFolder);

const classes = [];

function walk(folder) {
    const files = fs.readdirSync(folder);
    for (const file of files) {
        const fullPath = path.join(folder, file);
        const stat = fs.statSync(fullPath);
        if (stat.isDirectory()) {
            walk(fullPath);
        } else if (file.endsWith('.as')) {
            const fullyQualifiedName = fullPath
                .replace(srcFolder, '')
                .replace(/\\/g, '/')
                .replace(/^\//, '')
                .replace(/\//g, '.')
                .replace(/\.as$/, '');
            classes.push(fullyQualifiedName);
        }
    }
}

walk(srcFolder);
console.log('Classes found:', classes.length);

let dummyContent = 'package {\n';
dummyContent += '';

classes.forEach(className => {
    const parts = className.split('.');
    const shortName = parts[parts.length - 1];
    dummyContent += `    import ${className};${shortName};\n`;
});

dummyContent += `
    public class Index {
        public function Index() {
            
        }
    }
}`;

const dummyFilePath = path.join(srcFolder, 'index.as');
fs.writeFileSync(dummyFilePath, dummyContent);
console.log(`Dummy file created at: ${dummyFilePath}`);