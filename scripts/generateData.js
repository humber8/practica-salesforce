const fs = require('fs');
const path = require('path');

const NUM_ACCOUNTS = 20;
const records = [];

for (let i = 1; i <= NUM_ACCOUNTS; i++) {
    const accountRef = `AccountRef${i}`;
    
    // Create Account record
    const account = {
        attributes: {
            type: 'Account',
            referenceId: accountRef
        },
        Name: `Cuenta Masiva de Prueba ${i}`,
        Phone: `+10000000${i.toString().padStart(2, '0')}`,
        Fecha_de_ingreso_gerencia__c: '2024-05-01',
        Contacts: {
            records: [
                {
                    attributes: {
                        type: 'Contact',
                        referenceId: `ContactRef${i}_A`
                    },
                    FirstName: `Contacto A`,
                    LastName: `Asociado a Cuenta ${i}`,
                    Email: `contacto.a.${i}@ejemplo.com`
                },
                {
                    attributes: {
                        type: 'Contact',
                        referenceId: `ContactRef${i}_B`
                    },
                    FirstName: `Contacto B`,
                    LastName: `Asociado a Cuenta ${i}`,
                    Email: `contacto.b.${i}@ejemplo.com`
                }
            ]
        },
        Opportunities: {
            records: [
                {
                    attributes: {
                        type: 'Opportunity',
                        referenceId: `OppRef${i}`
                    },
                    Name: `Oportunidad de Cuenta ${i}`,
                    StageName: 'Prospecting',
                    CloseDate: '2024-12-31',
                    Amount: Math.floor(Math.random() * 100000) + 10000
                }
            ]
        }
    };

    records.push(account);
}

const data = { records };

const outputPath = path.join(__dirname, '../data/sample-data-large.json');
fs.writeFileSync(outputPath, JSON.stringify(data, null, 2));

console.log(`Generados ${NUM_ACCOUNTS} cuentas con sus contactos y oportunidades en: ${outputPath}`);
