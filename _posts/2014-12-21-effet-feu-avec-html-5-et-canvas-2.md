---
title: Effet feu avec HTML 5 et Canvas
description: Effet feu avec HTML 5 et Canvas
layout: post
lang: fr
last_modified_at: 2021-03-12
---
<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function (event) {
        window.FireEffect = {};
        FireEffect.canvas = document.getElementById('tutorial');
        FireEffect.ctx = FireEffect.canvas.getContext('2d');
        FireEffect.width = FireEffect.canvas.width;
        FireEffect.height = FireEffect.canvas.height;

        FireEffect.panel = function () {
            var panel = [];
            for (var i = 0; i < FireEffect.width; i++) {
                panel[i] = [];
                for (var j = 0; j < FireEffect.height; j++) {
                    panel[i][j] = 0;
                }
            }
            return panel;
        }();

        // Hide some implem details with module
        FireEffect.palette = function () {
            var palette = [];
            addColorGradient(0, [0, 0, 0], 128, [255, 0, 0]);
            addColorGradient(129, [255, 0, 0], 170, [255, 255, 0]);
            addColorGradient(171, [255, 255, 0], 255, [255, 255, 255]);

            function addColorGradient(idxStart, colorStart, idxEnd, colorEnd) {
                var gradients = [];
                for (var i = 0; i < 3; i++) {
                    gradients.push(gradient(idxStart, colorStart[i], idxEnd, colorEnd[i]))
                }

                for (var i = idxStart; i <= idxEnd; i++) {
                    palette[i] = new Array(3);
                    palette[i][0] = gradients[0][i - idxStart];
                    palette[i][1] = gradients[1][i - idxStart];
                    palette[i][2] = gradients[2][i - idxStart]
                }
            }

            function gradient(x1, y1, x2, y2) {
                var res = [];
                var step = (y2 - y1) / (x2 - x1);
                for (var i = x1; i <= x2; i++) {
                    res.push(y1 + step * (i - x1))
                }
                return res;
            }

            return palette;
        }();

        FireEffect.updatePanel = function () {
            var i;
            for (var j = 0; j <= this.height - 3; j++) {
                for (i = 1; i < this.width - 1; i++) {
                    this.panel[i][j] = Math.floor((
                    this.panel[i - 1][j + 1] +
                    this.panel[i + 1][j + 1] +
                    this.panel[i][j + 1] +
                    this.panel[i][j + 2]) / 4);
                }
            }
            for (i = 0; i < this.width; i++) {
                this.panel[i][this.height - 1] = Math.floor(Math.random() * 256);
                this.panel[i][this.height - 2] = Math.floor(Math.random() * 256);
            }
        };

        FireEffect.render = function (ctx) {
            var canvasData = ctx.createImageData(this.width, this.height);
            for (var i = 0; i < this.width; i++) {
                for (var j = 0; j < this.height; j++) {
                    // Index of the pixel in the array
                    var idx = (i + j * this.width) * 4;

                    var idxPanel = this.panel[i][j];
                    canvasData.data[idx + 0] = this.palette[idxPanel][0]; // Red channel
                    canvasData.data[idx + 1] = this.palette[idxPanel][1]; // Green channel
                    canvasData.data[idx + 2] = this.palette[idxPanel][2]; // Blue channel
                    canvasData.data[idx + 3] = 255; // Alpha channel
                }
            }
            ctx.putImageData(canvasData, 0, 0);
        };

        FireEffect.mainLoop = function () {
            var s = performance.now();
            FireEffect.render(FireEffect.ctx);
            var e = performance.now();
            FireEffect.updatePanel();
            var e2 = performance.now();
            document.getElementById('perfDraw').value = e - s;
            document.getElementById('perfCalculate').value = e2 - e;
        };

        function main() {
            FireEffect.stopMain = window.requestAnimationFrame(main);
            FireEffect.mainLoop()
        }

        main(); // Start the cycle
    });
</script>

<style type="text/css">
    canvas { border: 2px solid black; }
</style>

Après une [première démo](effet-feu-avec-html-5-et-canvas.html) avec la balise canvas, j'étais un
peu frustré par les performances. Voici donc une version plus aboutie.

Les performances sont bien meilleures grâce à l'utilisation de `requestAnimationFrame` à la place de
`setTimeout` pour la boucle principale et `putImageData` à la place de `fillRect` pour remplir un
canvas pixel par pixel.

<canvas id="tutorial" width="858" height="300"></canvas>

Perf calculate: <input type="text" id="perfCalculate" />

Perf draw: <input type="text" id="perfDraw" />

<input type="button" value="Démarrer" onClick="init()" />  

## Correction du bogue - mise à jour du 12 mars 2021

Il y a de nombreuses années, j'étais candidat chez Criteo. Mon intervieweur avait pris le temps de regarder mon blog 
et était tombé sur cette page. Il avait immédiatement remarqué un truc bizarre; des triangles asymétriques se formaient.
J'avais rapidement regardé le code après l'entretien, sans trouver le bogue. Et cette discussion est restée dans un coin de ma tête.

J'ai décidé d'y repasser un peu de temps et il y avait en fait 2 bogues.
- [d73c479](https://github.com/YannMoisan/blog/pull/25/commits/d73c479915a6703869e9f7d53becad31a0f13288) :
  le calcul balayait d'abord les colonnes puis les lignes (au lieu de l'inverse) 
- [264eda5](https://github.com/YannMoisan/blog/pull/25/commits/264eda5c0d22656236d1600dba940fa6c50bfc0d) : le calcul se faisait du bas vers le haut (au lieu de l'inverse) 

Ces deux bogues ont la même conséquence : le calcul des pixels précédents impactent le calcul des pixels suivants.

C'est enfin corrigé !