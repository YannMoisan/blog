---
title: Effet feu avec HTML 5 et Canvas
description: Effet feu avec HTML 5 et Canvas
layout: post
lang: fr
---
<script type="text/javascript">
    var WIDTH=100;
    var HEIGHT=50;
    var panel = new Array(WIDTH);
    var cc = new Array(256);

    function init() {
        initColors();
        initPanel();  
        setInterval('draw()', 500);
    }

function initColors() {
    for (c=0; c<256; c++) {
        cc[c]="rgb("+c+","+c+","+c+")";
    }
}

function initPanel() {
    for (var i=0; i<WIDTH; i++) {
        panel[i] = new Array(HEIGHT);
        for (var j=0; j<HEIGHT; j++) {
            panel[i][j] = 255;
        }
    }
} 

function updatePanel() {
    var s = new Date();
    for (var i=1; i<WIDTH-1; i++) {
        for (var j=HEIGHT-3; j>0; j--) {
            panel[i][j] = Math.floor((
                        panel[i-1][j+1]+
                        panel[i+1][j+1]+
                        panel[i][j+1]+
                        panel[i][j+2])/4);
        }
    }
    for (var i=0; i<WIDTH; i++) {
        panel[i][HEIGHT-1] = Math.floor(Math.random()*255);
        panel[i][HEIGHT-2] = Math.floor(Math.random()*255);
    }
}

function _draw1(ctx) {
    for (var i=0; i<WIDTH; i++) {
        for (var j=0; j<HEIGHT; j++) {
            ctx.fillStyle=cc[panel[i][j]];
            ctx.fillRect(i*4,j*4,4,4);
        }
    }
}

function _draw2(ctx) {
    for (var j=0; j<HEIGHT; j++) {
        ctx.moveTo(0,j)
            for (var i=0; i<WIDTH; i++) {
                ctx.beginPath();
                ctx.strokeStyle=cc[panel[i][j]];
                ctx.moveTo(i,j);
                ctx.lineTo(i+1,j);
                ctx.stroke();
            }
    }
}

function draw(){
    var canvas = document.getElementById('tutorial');
    if (canvas.getContext){
        var ctx = canvas.getContext('2d');
        var s = new Date();	
        _draw1(ctx);
        var e = new Date();
        updatePanel();
        var e2 = new Date();
        document.getElementById('perfDraw').value = e-s;
        document.getElementById('perfCalculate').value = e2-e;
    }
}

</script>
<style type="text/css">
    canvas { border: 2px solid black; }
</style>

Voici mon premier essai d'utilisation de la balise `<canvas>`, qui permet de dessiner dans une page
HTML, en codant en JavaScript. Un algorithme assez simple permet de simuler l'effet d'un feu. Un
clic sur le bouton permet de démarrer la démo. Les performances sont affichées dans les champs de
texte.

<canvas id="tutorial" width="400" height="200"></canvas>

Perf calculate: <input type="text" id="perfCalculate" />

Perf draw: <input type="text" id="perfDraw" />

<input type="button" value="Démarrer" onClick="init()" />  


