Program Ed_Cobol;            { mise … jour : 23/07/1991 }

{
Titre : Editeur de fichiers sources Cobol.

Auteur: Pr‚martin Patrick.
Date de cr‚ation de la premiŠre version (1.0): 29_30_31 d‚cembre 1990.
Date de cr‚ation de la version 'Orient‚e Objet' (2.0): 09/03/1991.
                                                       10/03/1991.
                                                (2.1): 17/07/1991.
                                                (d‚mo) 23/07/1991.

Ce programme  est un editeur de  texte pour  cr‚er ses propres  programmes en
COBOL sans … avoir … penser aux diff‚rentes marges: 7, A (8), B (12), ni … la
limitation des lignes … 72 colonnes dont les 6 premiŠres sont inutilis‚es.
}

{$M 16384,0,16384}
{ $define demo_vers}

Uses Crt,
     olf_software,
     U_Aff_Chaine,
     U_Curseur,
     U_Fenetre,
     U_Traitement,
     U_Utilitaire,
     U_Variables;

Procedure Presentation;
Begin { presentation }
  Reset_Screen;
  Type_Cadre := 6;
  Window_Fond_Cadre_Bis (2, 2, 79, 23, Blue, Lightgray, Black);
  Window_Titre ('Editeur de fichiers sources Cobol.', Blue, Brown);
  Textcolor (Yellow);
  Textbackground (Blue);
  Writeln;
  Affic_Center_Ln ('Auteur: Premartin Patrick');
  Writeln;
  Affic_Center_Ln (Concat ('Version: ', Num_Version));
  Writeln;
  Affic_Center_Ln (Concat ('Dat‚e du ', Date_Version));
  Writeln;
  Writeln;
  Writeln ('     Ce programme vous permet de taper vos listings en COBOL,  les marges A');
  Writeln ('  et B sont indiqu‚es,  la colonne 7 aussi.  Les d‚passements de la colonne');
  Writeln ('  72 sont impossibles.');
  Writeln;
{$IFDEF DEMO_VERS}
  writeln ('     Ceci est la version de d‚monstration. Toutes les options sont');
  writeln ('  accessibles sauf les sauvegardes sur disque. Vous pouvez tout de mˆme');
  writeln ('  vous faire une opinion sur ce programme...');
{$ELSE}
  Writeln ('     Ce programme a ‚t‚ fait en Turbo Pascal de Borland. Une limitation');
  Writeln ('  importante ‚xiste: vos fichiers COBOL ne devront pas d‚passer la longueur');
  Writeln ('  de ', Nb_Max_Ligne, ' lignes. Ceci est du … des problŠmes de structure.');
{$ENDIF}
  Writeln;
  Writeln ('     Afin d''obtenir des programmes plus longs  (le COBOL demandant beaucoup');
  Writeln ('  de place), tapez les morceaux de votre programme et  sauvez les sous  des');
  Writeln ('  noms differents, ensuite, faites-vous un fichier de linkage des morceaux.');
  Writeln ('  Reportez-vous au programme LK_COBOL.EXE qui r‚alise cette op‚ration.');
  Writeln;
  Attente_Appuit_Touche;
  Clear_Window
End; { presentation }

Begin { ed_cobol }
{$ifdef demo_vers}
  init_licence ('DEMOEDCO');
  init_olf_message (mess_demo);
{$else}
  init_licence ('EDCO');
  init_olf_message (mess_shareware);
{$endif}
  init_olf_software ('Editeur Cobol '+num_version, '(c) Patrick Pr‚martin '+date_version);
  Curseur_Off;
  Reset_Screen;
  Initialisation;
  Presentation;
  Curseur_Pave;
  Traitement;
  Reset_Screen;
  Curseur_Bas
End. { ed_cobol }
