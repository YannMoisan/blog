---
title: Simulateur de revenus pour freelance
description: Simulateur de revenus pour freelance
layout: post
lang: fr
---
<script>
    function updateDouble() {
// 2024
// PASS 43992e brut
// 6762 brut pour valider 4T de retraite
// 8230 par foyer fiscale tax PUMa
        // Récupère la valeur de l'input

        let imposition = document.querySelector('input[name="imposition"]:checked').value;
        //console.log(selectedValue)

        let salaireNet = parseFloat(document.getElementById("numberInput").value);
        let ca = parseFloat(document.getElementById("ca").value);
        let nombreDeParts = parseFloat(document.getElementById("nombreDeParts").value);
        let autresRevenus = parseFloat(document.getElementById("autresRevenus").value);

        // Calcule le double
        let chargesSocialesSasuIS = salaireNet * 0.80;
        let chargesSocialesSasuIR = salaireNet * 0.80;
        let chargesSocialesEurlIS = salaireNet * 0.45;
        let chargesSocialesEurlIR = (ca / 1.45) * 0.45;

        let salaireSuperBrutSasuIS = salaireNet + chargesSocialesSasuIS;
        let salaireSuperBrutSasuIR = salaireNet + chargesSocialesSasuIR;
        let salaireSuperBrutEurlIS = salaireNet + chargesSocialesEurlIS;
        let salaireSuperBrutEurlIR = salaireNet + chargesSocialesEurlIR;

        let beneficeBrutSasuIS = ca - salaireSuperBrutSasuIS;
        let beneficeBrutSasuIR = ca - salaireSuperBrutSasuIR;
        let beneficeBrutEurlIS = ca - salaireSuperBrutEurlIS;
        let beneficeBrutEurlIR = ca - salaireSuperBrutEurlIR;

        let isSasuIS = beneficeBrutSasuIS < 42500 ? beneficeBrutSasuIS * 0.15 : 0.15 * 42500 + (beneficeBrutSasuIS - 42500) * 0.25;
        let isSasuIR = 0
        let isEurlIS = beneficeBrutEurlIS < 42500 ? beneficeBrutEurlIS * 0.15 : 0.15 * 42500 + (beneficeBrutEurlIS - 42500) * 0.25;
        let isEurlIR = 0

        let beneficeNetSasuIS = beneficeBrutSasuIS - isSasuIS;
        let beneficeNetSasuIR = beneficeBrutSasuIR - isSasuIR;
        let beneficeNetEurlIS = beneficeBrutEurlIS - isEurlIS;
        let beneficeNetEurlIR = beneficeBrutEurlIR - isEurlIR;

        let cotisationsSocialesSasuIS = 0
        let cotisationsSocialesSasuIR = 0
        let cotisationsSocialesEurlIS = beneficeNetEurlIS * 0.45
        let cotisationsSocialesEurlIR = 0

        let revenuImposableSasuIS = salaireNet + (imposition === "flat_tax" ? 0 : beneficeNetSasuIS * 0.6)
        let revenuImposableSasuIR = ca - salaireNet * 0.54 // les charges patronales sont deductibles
        let revenuImposableEurlIS = salaireNet * 0.9 + (imposition === "flat_tax" ? 0 : beneficeNetSasuIS * 0.6)
        let revenuImposableEurlIR = ca - chargesSocialesEurlIR // les charges sont deductibles ?

        let ratioIrSasuIS = revenuImposableSasuIS / (revenuImposableSasuIS + autresRevenus)
        let ratioIrSasuIR = revenuImposableSasuIR / (revenuImposableSasuIR + autresRevenus)
        let ratioIrEurlIS = revenuImposableEurlIS / (revenuImposableEurlIS + autresRevenus)
        let ratioIrEurlIR = revenuImposableEurlIR / (revenuImposableEurlIR + autresRevenus)

        let irSasuIS = calculImpot2(revenuImposableSasuIS + autresRevenus, nombreDeParts)
        let irSasuIR = calculImpot2(revenuImposableSasuIR + autresRevenus, nombreDeParts) // les charges patronales sont deductibles
        let irEurlIS = calculImpot2(revenuImposableEurlIS + autresRevenus, nombreDeParts)
        let irEurlIR = calculImpot2(revenuImposableEurlIR + autresRevenus, nombreDeParts)

        let flatTaxSasuIS = beneficeNetSasuIS * ((imposition == "flat_tax") ? 0.30 : 0.172)
        let flatTaxSasuIR = 0
        let flatTaxEurlIS = beneficeNetEurlIS * ((imposition == "flat_tax") ? 0.128 : 0) //beneficeNetEurlIS * 0.128
        let flatTaxEurlIR = 0

        let dividendesNetSasuIS = beneficeNetSasuIS - flatTaxSasuIS - cotisationsSocialesSasuIS
        let dividendesNetSasuIR = 0
        let dividendesNetEurlIS = beneficeNetEurlIS - flatTaxEurlIS - cotisationsSocialesEurlIS
        let dividendesNetEurlIR = 0

        let revenuNetSasuIS = salaireNet - irSasuIS[0] * ratioIrSasuIS + dividendesNetSasuIS
        let revenuNetSasuIR = ca - chargesSocialesSasuIR - irSasuIR[0] * ratioIrSasuIR
        let revenuNetEurlIS = salaireNet - irEurlIS[0] * ratioIrEurlIS + dividendesNetEurlIS
        let revenuNetEurlIR = ca - chargesSocialesEurlIR - irEurlIR[0] * ratioIrEurlIR
        // Affiche le résultat
        //document.getElementById("salaireSuperBrutSasuIS").innerText = salaireSuperBrutSasuIS;
        document.getElementById("chargesSocialesSasuIS").innerText = show(chargesSocialesSasuIS);
        document.getElementById("chargesSocialesSasuIR").innerText = show(chargesSocialesSasuIR);
        document.getElementById("chargesSocialesEurlIS").innerText = show(chargesSocialesEurlIS);
        document.getElementById("chargesSocialesEurlIR").innerText = show(chargesSocialesEurlIR);

        document.getElementById("salaireNetSasuIS").innerText = show(salaireNet);
        document.getElementById("salaireNetSasuIR").innerText = show(salaireNet);
        document.getElementById("salaireNetEurlIS").innerText = show(salaireNet);
        document.getElementById("salaireNetEurlIR").innerText = show(ca - chargesSocialesEurlIR);

        document.getElementById("isSasuIS").innerText = show(isSasuIS);
        //document.getElementById("isSasuIR").innerText = show(isSasuIR);
        document.getElementById("isEurlIS").innerText = show(isEurlIS);

        //document.getElementById("cotisationsSocialesSasuIS").innerText = show(cotisationsSocialesSasuIS);
        //document.getElementById("cotisationsSocialesSasuIR").innerText = show(cotisationsSocialesSasuIR);
        document.getElementById("cotisationsSocialesEurlIS").innerText = show(cotisationsSocialesEurlIS);

        document.getElementById("dividendesNetSasuIS").innerText = show(dividendesNetSasuIS);
        //document.getElementById("dividendesNetSasuIR").innerText = show(dividendesNetSasuIR);
        document.getElementById("dividendesNetEurlIS").innerText = show(dividendesNetEurlIS);

        document.getElementById("flatTaxSasuIS").innerText = show(flatTaxSasuIS);
        //document.getElementById("flatTaxSasuIR").innerText = show(flatTaxSasuIR);
        document.getElementById("flatTaxEurlIS").innerText = show(flatTaxEurlIS);

        document.getElementById("irSasuIS").innerText = showImpot(irSasuIS);
        document.getElementById("irSasuIR").innerText = showImpot(irSasuIR);
        document.getElementById("irEurlIS").innerText = showImpot(irEurlIS);
        document.getElementById("irEurlIR").innerText = showImpot(irEurlIR);

        document.getElementById("revenuImposableSasuIS").innerText = show(revenuImposableSasuIS);
        document.getElementById("revenuImposableSasuIR").innerText = show(revenuImposableSasuIR);
        document.getElementById("revenuImposableEurlIS").innerText = show(revenuImposableEurlIS);
        document.getElementById("revenuImposableEurlIR").innerText = show(revenuImposableEurlIR);

        document.getElementById("revenuNetSasuIS").innerText = show(revenuNetSasuIS);
        document.getElementById("revenuNetSasuIR").innerText = show(revenuNetSasuIR);
        document.getElementById("revenuNetEurlIS").innerText = show(revenuNetEurlIS);
        document.getElementById("revenuNetEurlIR").innerText = show(revenuNetEurlIR);
    }

   function showImpot(arr) {
        return isNaN(arr[0]) ? "" : Math.round(arr[0]) + " (" + (100*arr[1]).toFixed(1) + "%)"
   }
   function show(n) {
       return isNaN(n) ? "" : Math.round(n)
       } 

    function calculImpot2(salaireNet, nombreDeParts) {
        // PLAFONNEMENT DES EFFETS DU QUOTIENT FAMILIAL
        let impot = nombreDeParts * calculImpot(salaireNet / nombreDeParts)
        if (nombreDeParts > 2) {
            let impot2parts = 2 * calculImpot(salaireNet / 2)
            impot = Math.max(impot, impot2parts - 1759 * (2 * (nombreDeParts - 2)))
        }
        return [impot, impot/salaireNet]
    }

    function calculImpot(salaireNet) {
        let impot = 0;

        // Tranche 0% : de 0 à 10 777 €
        if (salaireNet <= 11294) {
            return impot;
        }

        // Tranche 11% : de 10 778 € à 27 478 €
        if (salaireNet > 11294 && salaireNet <= 28797) {
            impot += (salaireNet - 11294) * 0.11;
            return impot;
        }

        // Tranche 30% : de 27 479 € à 78 570 €
        if (salaireNet > 28797 && salaireNet <= 82341) {
            impot += (28797 - 11294) * 0.11;  // 11% sur la première tranche
            impot += (salaireNet - 28797) * 0.30;
            return impot;
        }

        // Tranche 41% : de 78 571 € à 168 994 €
        if (salaireNet > 82341 && salaireNet <= 177106) {
            impot += (28797 - 11294) * 0.11;  // 11% sur la première tranche
            impot += (82341 - 28797) * 0.30;  // 30% sur la deuxième tranche
            impot += (salaireNet - 82341) * 0.41;
            return impot;
        }

        // Tranche 45% : au-delà de 168 994 €
        if (salaireNet > 177106) {
            impot += (28797 - 11294) * 0.11;  // 11% sur la première tranche
            impot += (82341 - 28797) * 0.30;  // 30% sur la deuxième tranche
            impot += (177106 - 82341) * 0.41; // 41% sur la troisième tranche
            impot += (salaireNet - 177106) * 0.45; // 45% sur le reste
            return impot;
        }
    }
</script>

Chiffre d'affaires annuel : <input type="number" id="ca" oninput="updateDouble()" />

Salaire net annuel : <input type="number" id="numberInput" oninput="updateDouble()" />

Imposition des dividendes :
<input type="radio" id="option1" name="imposition" value="flat_tax" checked oninput="updateDouble()">
<label for="option1">Flat tax</label>
<input type="radio" id="option2" name="imposition" value="bareme" oninput="updateDouble()">
<label for="option2">Barême progressif</label>

<div style="background-color: #f0f8ff;margin-bottom: 15px;">
    <p>Foyer fiscal</p>
    <div style="margin-bottom: 15px;">
        Nombre de parts : <input type="number" id="nombreDeParts" oninput="updateDouble()" /> 
    </div>
    <div style="margin-bottom: 15px;">
        Autres revenus nets imposables : <input type="number" id="autresRevenus" oninput="updateDouble()" />
    </div>
</div>

<table border="0" cellspacing="0" cellpadding="0" class="ta1">
    <colgroup>
        <col width="121">
        <col width="131">
        <col width="135">
        <col width="99">
        <col width="99">
        <col width="99">
        <col width="99">
    </colgroup>
    <tbody>
        <tr class="ro1">
            <td colspan="3" style="text-align:left;">&nbsp;</td>
            <td style="text-align:left;">SASU IS</td>
            <td style="text-align:left;">SASU IR</td>
            <td style="text-align:left;">EURL IS</td>
            <td style="text-align:left;">EURL IR</td>
        </tr>
        <tr class="ro1">
            <td rowspan="2" style="text-align:left;">Dépenses</td>
            <td rowspan="2" style="text-align:left;">Salaire super brut</td>
            <td style="text-align:left;">Charges sociales</td>
            <td style="text-align:right;"><span id="chargesSocialesSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="chargesSocialesSasuIR">&nbsp;</span></td>
            <td style="text-align:right;"><span id="chargesSocialesEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="chargesSocialesEurlIR">&nbsp;</span></td>
        </tr>
        <tr class="ro1">
            <td style="text-align:left;">Salaire net</td>
            <td style="text-align:right;"><span id="salaireNetSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="salaireNetSasuIR">&nbsp;</span></td>
            <td style="text-align:right;"><span id="salaireNetEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="salaireNetEurlIR">&nbsp;</span></td>
        </tr>
        <tr class="ro1">
            <td rowspan="4" style="text-align:left;">Bénéfices bruts</td>
            <td rowspan="3" style="text-align:left;">Bénéfices net</td>
            <td style="text-align:left;">Dividendes net</td>
            <td style="text-align:right;"><span id="dividendesNetSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="dividendesNetSasuIR">n/a</span></td>
            <td style="text-align:right;"><span id="dividendesNetEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="dividendesNetEurlIR">n/a</span></td>
        </tr>
        <tr class="ro1">
            <td style="text-align:left;">Impôts sur dividendes</td>
            <td style="text-align:right;"><span id="flatTaxSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="flatTaxSasuIR">n/a</span></td>
            <td style="text-align:right;"><span id="flatTaxEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="flatTaxEurlIR">n/a</span></td>
        </tr>
        <tr class="ro1">
            <td style="text-align:left;">Cotisations sociales</td>
            <td style="text-align:right;"><span id="cotisationsSocialesSasuIS">n/a</span></td>
            <td style="text-align:right;"><span id="cotisationsSocialesSasuIR">n/a</span></td>
            <td style="text-align:right;"><span id="cotisationsSocialesEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="cotisationsSocialesEurlIR">n/a</span></td>
        </tr>
        <tr class="ro1">
            <td colspan="2" style="text-align:left;">IS</td>
            <td style="text-align:right;"><span id="isSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="isSasuIR">n/a</span></td>
            <td style="text-align:right;"><span id="isEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="isEurlIR">n/a</span></td>
        </tr>
        <tr class="ro1">
            <td colspan="3" style="text-align:left;">Revenu imposable</td>
            <td style="text-align:right;"><span id="revenuImposableSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="revenuImposableSasuIR">&nbsp;</span></td>
            <td style="text-align:right;"><span id="revenuImposableEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="revenuImposableEurlIR">&nbsp;</span></td>
        </tr>
        <tr class="ro1">
            <td colspan="3" style="text-align:left;">Impôt sur le revenu</td>
            <td style="text-align:right;"><span id="irSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="irSasuIR">&nbsp;</span></td>
            <td style="text-align:right;"><span id="irEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="irEurlIR">&nbsp;</span></td>
        </tr>
        <tr class="ro1">
            <td colspan="3" style="text-align:left;">Revenu net d’impôts</td>
            <td style="text-align:right;"><span id="revenuNetSasuIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="revenuNetSasuIR">&nbsp;</span></td>
            <td style="text-align:right;"><span id="revenuNetEurlIS">&nbsp;</span></td>
            <td style="text-align:right;"><span id="revenuNetEurlIR">&nbsp;</span></td>
        </tr>
    </tbody>
</table>

# Simulateur de revenus pour freelance

Vous êtes en fin de droits Pôle Emploi ou n'avez pas droit au chômage ? Ce simulateur est fait pour vous.

[Après avoir exploré les options pour les bénéficiaires du chômage](micro-entreprise-ou-sasu.html), ce simulateur
vous guide dans le choix du statut juridique le plus avantageux fiscalement, en toute simplicité.

# Pourquoi ce simulateur ?

Comparer les différents statuts d’entreprise, comme l'EURL et la SASU, peut être complexe. 
Ce simulateur simplifie cette comparaison pour vous permettre de faire un choix éclairé. 
Il prend en compte l'impôt sur le revenu afin de vous offrir une analyse complète et équitable.

> ⚠️ **Disclaimer** : Je ne suis pas expert-comptable. 
Ce simulateur a pour but de vous donner une idée approximative des flux financiers. Il ne remplace pas un conseil professionnel.

# Que compare ce simulateur ?

Le simulateur compare deux types de structures juridiques :

- EURL (Entreprise Unipersonnelle à Responsabilité Limitée)
- SASU (Société par Actions Simplifiée Unipersonnelle)

Pour chaque structure, deux options fiscales sont prises en compte :

- Impôt sur les Sociétés (IS).
- Impôt sur le Revenu (IR).

# Simplicité dans le calcul

Afin de simplifier l’utilisation, les charges d’exploitation (frais généraux, loyers, assurances, etc.) ne sont pas intégrées au calcul, 
car elles ne modifient pas la logique de comparaison. Il vous suffit de soustraire vos charges d’exploitation de votre chiffre d’affaires pour obtenir le montant à indiquer dans le simulateur.

# Liens

- [Simulateur complet pour freelance](https://decodage-fiscal.fr/guides-simulateurs/simulateur-complet-independant-freelance)
- [Simulateur pour freelance en SASU](http://sasu.mokatech.net/)
- [Urssaf - simulateur SASU](https://mon-entreprise.urssaf.fr/simulateurs/sasu)
- [Urssaf - simulateur EURL](https://mon-entreprise.urssaf.fr/simulateurs/eurl)
