//+------------------------------------------------------------------+
//
//	AlDobleM - http://www.aulafuturos.com - alfredo@aulafuturos.com
//  Copyright (C) 2008  Alfredo Alexandre
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//+-------------------------------------------------------------------+
//	AlDobleM - http://www.aulafuturos.com - alfredo@aulafuturos.com
//  Copyright (C) 2008  Alfredo Alexandre
//
//  Este programa es software libre: usted puede redistribuirlo y/o modificarlo 
//  bajo los términos de la Licencia Pública General GNU publicada 
//  por la Fundación para el Software Libre, ya sea la versión 3 
//  de la Licencia, o (a su elección) cualquier versión posterior.
//
//  Este programa se distribuye con la esperanza de que sea útil, pero 
//  SIN GARANTÍA ALGUNA; ni siquiera la garantía implícita 
//  MERCANTIL o de APTITUD PARA UN PROPÓSITO DETERMINADO. 
//  Consulte los detalles de la Licencia Pública General GNU para obtener 
//  una información más detallada. 
//
//  Debería haber recibido una copia de la Licencia Pública General GNU 
//  junto a este programa. 
//  En caso contrario, consulte <http://www.gnu.org/licenses/>.
//
//+------------------------------------------------------------------+

#property  copyright "Copyright (c) Alfredo Alexandre, mailto:alfredo@aulafuturos.com"
#property  link      "http://www.aulafuturos.com/"

#property indicator_separate_window
#property indicator_buffers 8

#property indicator_color1 Blue
#property indicator_color5 Blue
#property indicator_color2 Green

#property indicator_color3 Red
#property indicator_color4 Black

#property indicator_color8 Blue

#property indicator_width2 2

extern string Copyright = "www.aulafuturos.com - Copyright (c) Alfredo Alexandre, mailto:alfredo@aulafuturos.com";

extern int Av40         = 200;   // Es para el macd azul
extern int Av13         = 13;    // Es para el macd verde
extern int Sig1         = 9;     // Linea de puntos de la azul
extern int Sig2         = 6;     // Linea de puntos de la verde
extern double Bandinf   = -0.01; // Banda Inferior
extern double Bandsup   = 0.01;  // Banda Superior
extern double n         = 3;     // Multiplicador del azul
extern double n1        = 0.5;   // Multiplicador del verde
extern int Av40Fina     = 8;     // Es para el macd azul (segundo valor)
extern int AvFina       = 8;     // Es para el macd verde (segundo valor)


// Líneas visalizadas (buffers)
double arrMacdVerde[];
double arrMacdAzul[];
double arrPunteadaVerde[];
double arrPunteadaAzul[];
double arrLisaAzul[];

double arrLineaCero[];
double arrBandaSup[];
double arrBandaInf[];

double mediaAzul[];
double mediaVerde[];
double sobreMediaAzul[];
double sobreMediaVerde[];

string symbol;

int init() {

   //SetIndexBuffer(1, arrLineaCero);  // Línea 0
   
   SetIndexBuffer(0, arrMacdAzul);
   SetIndexBuffer(1, arrMacdVerde);
   SetIndexBuffer(2, arrPunteadaVerde);   
   SetIndexBuffer(3, arrPunteadaAzul);
   SetIndexBuffer(4, arrLisaAzul);
   SetIndexBuffer(5, arrBandaSup);
   SetIndexBuffer(6, arrBandaInf);
   SetIndexBuffer(7, arrLineaCero);
   
   SetIndexLabel(0,"MACD Largo");
   SetIndexLabel(1,"MACD Corto");
   SetIndexLabel(2,"Exponencial larga");   
   SetIndexLabel(3,"Exponencial corta");
   SetIndexLabel(5,"Banda superior");
   SetIndexLabel(6,"Banda inferior");
   
   //---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   
   IndicatorDigits(Digits+1);
   
   // Nombre corto para el título de la ventana
   IndicatorShortName("ALDOBLEM sobre "+Symbol()+" ("+Av13+","+Av40+")");

   symbol = Symbol();
   
   return(0);
}
  
  
  
int start() {

   int limite;
  
   limite = Bars - 1;
   
   ArrayResize(mediaAzul, limite);
   ArrayResize(mediaVerde, limite);
   ArrayResize(sobreMediaAzul, limite);
   ArrayResize(sobreMediaVerde, limite);
   
   ArraySetAsSeries(mediaAzul, true);
   ArraySetAsSeries(mediaVerde, true);
   
   for(int i=0; i<limite; i++) {
      mediaAzul[i]         = iMA(NULL,0,Av40,1,MODE_EMA,PRICE_CLOSE,i);
      mediaVerde[i]        = iMA(NULL,0,Av13,1,MODE_EMA,PRICE_CLOSE,i);
   }
   
   for(i=0; i<limite; i++) {
      sobreMediaAzul[i]    = iMAOnArray(mediaAzul,0,8,0,MODE_EMA,i);
      sobreMediaVerde[i]   = iMAOnArray(mediaVerde,0,8,0,MODE_EMA,i);   
   }
   
   for(i=0; i<limite; i++) {
      arrMacdAzul[i]    = (((mediaAzul[i] - sobreMediaAzul[i])*100) / mediaAzul[i])*n; 
      arrLisaAzul[i] = arrMacdAzul[i];
      
      arrMacdVerde[i]   = (((mediaVerde[i] - sobreMediaVerde[i])*100) / mediaVerde[i])*n1;   
   }   

   for(i=0; i<limite; i++) {
      arrPunteadaAzul[i]=iMAOnArray(arrMacdAzul,Bars,Sig1,0,MODE_EMA,i);
      arrPunteadaVerde[i]=iMAOnArray(arrMacdVerde,Bars,Sig2,0,MODE_EMA,i);   
   }

   for(i=0; i<limite; i++) {
      arrLineaCero[i] = 0;
      arrBandaSup[i] = Bandsup;
      arrBandaInf[i] = Bandinf;   
   }

   return(0);
}
  
  
  