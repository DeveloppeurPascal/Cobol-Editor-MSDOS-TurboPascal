Unit U_Variables;           { Mise … jour le 21/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991.
      10/03/1991.
      18/07/1991.
      21/07/1991.

But: Cette unit‚ contient les d‚clarations utiles pour l'‚diteur de Cobol.
}
{ $define demo_vers}
Interface

Const
{ Constantes de version. }
{$IFDEF DEMO_VERS}
     Num_Version  : String [8]  = 'd‚mo 2.1';
{$ELSE}
     num_version  : string [3]  = '2.1';
{$ENDIF}
     Date_Version : String [10] = '21/07/1991';

{ Constantes de configuration. }
     Nb_Max_Carac = 66;  { de la colonne 7 … la colonne 72 incluses.       }
     Nb_Max_Ligne = 900; { nombre maximal de lignes d'un fichier source.
                           Type structur‚ prend au maximum 65520 octets,
                           Nb_Max_Ligne * (Nb_Max_Carac + 1) = 59400       }
     Nb_Col_Tab   = 5;   { largeur d'une tabulation                        }

{ Constantes de l'editeur. }
   Mode_Insert : Boolean = True; { Mode insertion ou pas ?                 }
   Mode_Indent : Boolean = True; { Mode d'indentation automatique ou pas ? }
   Mode_Time   : Boolean = True; { Affichage de l'heure ou pas ?           }
   Mode_Date   : Boolean = True; { Affichage de la date ou pas ?           }

{ Constantes couleurs. }
   c_noir       = 0;         c_gris_fonce    = 8;
   c_bleu       = 1;         c_bleu_clair    = 9;
   c_vert       = 2;         c_vert_clair    = 10;
   c_cyan       = 3;         c_cyan_clair    = 11;
   c_rouge      = 4;         c_rouge_clair   = 12;
   c_magenta    = 5;         c_magenta_clair = 13;
   c_brun       = 6;         c_jaune         = 14;
   c_gris_clair = 7;         c_blanc         = 15;
                             c_clignotement  = 128;

{ Couleurs de l'editeur. }
   c_col_txt_listing    = c_jaune;
   c_col_bck_listing    = c_noir;
   c_col_txt_ln_titre   = c_blanc;
   c_col_bck_ln_titre_1 = c_magenta;
   c_col_bck_ln_titre_2 = c_rouge;
   c_col_bck_ln_titre_3 = c_brun;
   c_col_bordure        = c_vert;
   c_col_form_cadre     = c_blanc;
   c_col_fond_cadre     = c_gris_clair;
   c_col_txt_titre_fen  = c_brun;
   c_col_bck_titre_fen  = c_noir;
   c_col_txt_titre_men  = c_brun;
   c_col_bck_titre_men  = c_blanc;
   c_col_txt_opt_men    = c_jaune;
   c_col_bck_opt_men    = c_vert;

Type
    T_Ligne       = String [Nb_Max_Carac];
    T_Tabl_Ligne  = Array [1..Nb_Max_Ligne] Of T_Ligne;
    T_Code_Source = Record
                      Nb_Lig : Integer;
                      Lignes : T_Tabl_Ligne
                    End;

Var
   X, Y,                  { coordonn‚es du curseur dans l'‚cran           }
   Num_Ligne_1,           { numero de la premiŠre ligne de l'ecran        }
   Lig         : Integer; { num‚ro de la ligne courante                   }
   ln_deb_bloc,
   ln_fin_bloc : integer; { num‚ro des lignes de debut et de fin de bloc  }

Implementation

begin
     x := 1;
     y := 1;
     num_ligne_1 := 1;
     lig := 1;
     ln_deb_bloc := 0;
     ln_fin_bloc := 0;
End. { Fin de l'unit‚ 'U_Variables'. }
