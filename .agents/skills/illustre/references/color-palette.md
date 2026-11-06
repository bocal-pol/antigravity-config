# Palette de Couleurs — Excalidraw (Neutre)

Palette neutre par défaut. Remplacer par la palette du projet si un `DESIGN.md` est disponible.

---

## Couleurs de Shape (10 catégories sémantiques)

| Catégorie | Stroke | Fill | Usage |
|---|---|---|---|
| Primaire | `#0047CC` | `#DBEAFE` | Actions principales, entités centrales |
| Secondaire | `#0891B2` | `#CFFAFE` | Éléments secondaires, support |
| Accent | `#B45309` | `#FEF3C7` | Points d'attention, décisions |
| Succès | `#15803D` | `#DCFCE7` | États réussis, validations |
| Avertissement | `#D97706` | `#FFF7ED` | Alertes, états à surveiller |
| Données | `#7C3AED` | `#EDE9FE` | Inputs, données, sources |
| Décision | `#B45309` | `#FEF3C7` | Losanges de décision |
| IA/LLM | `#0891B2` | `#F0FDFA` | Composants IA |
| Inactif | `#64748B` | `#F1F5F9` | États désactivés |
| Neutre | `#334155` | `#F8FAFC` | Éléments de structure |

---

## Hiérarchie de Texte (6 niveaux)

| Niveau | Couleur | Usage |
|---|---|---|
| Titre principal | `#0F172A` | Titres de slide |
| Titre accent | `#0066CC` | Sous-titres importants |
| Corps | `#334155` | Texte principal |
| Secondaire | `#64748B` | Labels, descriptions |
| Blanc | `#FFFFFF` | Texte sur fond sombre |
| Désactivé | `#94A3B8` | Éléments grisés |

---

## Éléments Structurels

| Élément | Couleur |
|---|---|
| Flèches | Hérite de la couleur stroke de l'élément source |
| Lignes structurelles | `#334155` |
| Points de référence (dots) | `#0066CC` (fill) / `#0047CC` (stroke) |
| Fond de canvas | `#FFFFFF` |
| Séparateurs de slides | `#CCCCCC` (pointillé) |

---

## Règles d'Application

1. **Utiliser Fill très pâle** — les fills foncés écrasent le texte
2. **Stroke toujours plus foncé** que le fill correspondant
3. **Jamais plus de 3 couleurs** de shapes dans un même diagramme
4. **Fond blanc uniquement** — pas de fond coloré global
5. **Pas de gradients** — flat colors uniquement dans Excalidraw
