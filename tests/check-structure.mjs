import { readFileSync, readdirSync } from 'node:fs';
import { resolve } from 'node:path';

const root = resolve(import.meta.dirname, '..');
const app = JSON.parse(readFileSync(resolve(root, 'app.json'), 'utf8'));
if (app.name !== 'GOVP for Business Central') throw new Error('Unexpected app name');
if (app.idRanges[0].from !== 71100 || app.idRanges[0].to !== 71149) throw new Error('Unexpected object range');
const source = readdirSync(resolve(root, 'src')).filter((name) => name.endsWith('.al')).map((name) => readFileSync(resolve(root, 'src', name), 'utf8')).join('\n');
for (const required of ["Source.Add('platform', 'business_central')", 'DataScope::Company', 'IsolatedStorage.Set', "'/connectors/issue'", "'Idempotency-Key'", 'tableextension 71100']) {
  if (!source.includes(required)) throw new Error(`Missing contract marker: ${required}`);
}
if (!source.includes('permissionset 71100 "GOVP Admin"') || !source.includes('tabledata "GOVP Setup" = RIMD')) {
  throw new Error('Missing least-privilege setup permission set');
}
for (const forbidden of ['Dataverse', 'Opportunity', 'CRM']) {
  if (source.includes(forbidden)) throw new Error(`Business Central connector must remain independent from ${forbidden}`);
}
console.log('Business Central source structure and GOVP contract markers passed.');
