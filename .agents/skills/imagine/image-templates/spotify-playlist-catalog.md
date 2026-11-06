---
name: spotify-playlist-catalog
type: reference
created: 2026-08-15
linked_template: spotify-playlist-cover
---

# Spotify Playlist Catalog — Genres & Situations

> Reference used by the `spotify-playlist-cover.md` template.
> For each playlist, detect the type (musical genre vs. situation/activity),
> select the matching entry, and inject it into the generation prompt.

---

## Section A — Musical genres

| Genre / Subgenre | Background (hex) | Color description | Archetype character | Prop |
|---|---|---|---|---|
| Heavy Metal / Thrash Metal | `#B03A2A` | Burnt brick red | Angry man, long greasy black hair, thick beard, black tank top, aggressive clenched-teeth expression | — |
| Death Metal / Black Metal | `#1A1010` | Near-black maroon | Pale man, black curtain hair, white and black corpse paint, tormented expression | — |
| Shock Rock | `#4A1820` | Very dark blood maroon | Macabre theatrical star, horror makeup (Alice-Cooper-style black drips), disheveled hair, top hat, sinister grin | Top hat (optional: snake over shoulders) |
| Punk / Hardcore | `#2A1F3D` | Violet-black | Person with colored mohawk, safety pins, ornamented black jacket, defiant look | — |
| Punk Rock | `#A83244` | Punchy crimson red | Classic punk, spiked or mohawk hair, studded perfecto jacket with patches and pins, torn t-shirt, defiant snarl | — |
| Punk Hardcore | `#38383A` | Raw charcoal-concrete gray | Athletic hardcore kid, very short buzzcut (visible short hair, NOT bald), tank top, tattoos, furious scream, neck veins | — (option: microphone) |
| Proto-punk | `#A8792E` | Grimy 70s mustard-ochre | Nervous wild figure (Iggy-Pop-type), bare-chested or open perfecto, long disheveled dark hair, wild and dangerous look | — |
| Skate Punk | `#2E7E8C` | Vivid 90s teal blue | Young punk skater, short bleached hair or backwards cap, band t-shirt, mischievous energetic smile | Skateboard |
| Skate Punk 2000s | `#3A78B4` | Vivid 2000s sky blue | Young 2000s pop-punk skater, spiked frosted-tip hair, band t-shirt, bracelets, mischievous energetic smile | Skateboard |
| Screamo / Skramz | `#2C3238` | Cold gray charcoal | Young singer mid-cathartic scream, emo fringe over one eye, black t-shirt, clenched eyes, neck tension, raw emotion | Microphone gripped with both hands |
| Nu Metal | `#3D4E4E` | Industrial green-slate gray | Young man in 2000s streetwear, shaved head or backwards cap, goatee, piercing, baggy hoodie, sullen dark expression | — |
| Speed Metal | `#2E3E70` | Deep electric indigo-blue | Guitarist mid-headbang, hair whipping through the air, studded leather jacket with patches, unleashed scream, motion lines | Flying V guitar |
| Nu Metal 90s | `#38322C` | Murky dark brown-gray | 90s nu-metal fan, dreadlocks or cornrows, baggy tracksuit/hoodie, goatee, anguished tormented expression, dark look | — |
| Speed Metal 80s | `#2E5E7A` | Electric 80s steel-blue | 80s headbanging metalhead, big metal mane, denim/leather jacket with patches, bullet belt, unleashed scream, motion lines | Flying V guitar |
| Doom Metal 70s | `#322E3A` | Gloomy occult violet-charcoal | 70s doom metalhead, long hair + sideburns + mustache, occult pendant, heavy menacing expression, hazy atmosphere | Occult pendant (cross/talisman) |
| Melodic Metal | `#34526A` | Cold melodic steel-blue | Scandinavian melodic-metal metalhead, long hair, leather/band t-shirt, playing guitar fervently, passionate melancholic expression | Electric guitar |
| Metalcore | `#2E4A5A` | Desaturated cold steel-blue | Young man, undercut or side-swept fringe, ear gauges, neck/arm tattoos, short beard, black t-shirt, hard intense look | — |
| Neue Deutsche Härte | `#3E4247` | Cold industrial steel-gray | Imposing muscular metalhead, severe short cut (visible short hair, not bald), industrial/martial strapped outfit, icy stare, discreet pyro sparks | — (discreet sparks/fire) |
| Classic Rock | `#8B4513` | Warm saddle brown | Man in his mid-forties, disheveled medium-length hair, open plaid shirt, cool relaxed air | — |
| Rockabilly | `#C0473A` | 50s hot-rod cherry red | 50s greaser, big slicked-back pompadour + sideburns, leather/denim jacket over a white t-shirt, charming cocky smile | Vintage hollow-body guitar |
| Rock 'n' Roll | `#CC8A2E` | Warm golden-amber spotlight | Electrified 50s showman, slicked pompadour, flashy stage jacket, big charismatic smile, playing guitar dynamically | Electric guitar |
| Dad Rock | `#4E6478` | Warm denim-blue | Friendly man in his fifties, graying hair + mustache (full, NOT bald), shirt open over a band t-shirt, nostalgic smile, a bit of air-guitar | Air-guitar (or vinyl record) |
| Psychedelic Rock | `#4A3A7A` | Psychedelic indigo-violet | 60s hippie musician, long hair or big afro + headband, small round tinted glasses, fringed/paisley jacket, dreamy distant gaze | Round tinted glasses |
| Soft Rock | `#C08E72` | Warm felted 70s rosy-beige | Singer-songwriter, mid-length feathered hair, light mustache/beard, open large-collar shirt, warm smile | Acoustic guitar |
| Indie Rock / Shoegaze | `#6B7FA3` | Slate blue-gray | Person with mid-length hair, fringe over the eyes, oversized turtleneck sweater, slightly lost gaze | — |
| Shoegazing | `#7A72A0` | Hazy powdery lavender-violet | Introverted musician, long fringe hiding the eyes, head down toward guitar/pedals, shy ethereal posture (the one non-frontal cover) | Electric guitar worn low |
| Nu Gaze / Nu-Gazing | `#96708E` | Modern hazy powdery mauve-pink | Modern shoegaze musician, long fringe over the eyes (or beanie), head down, dreamy gaze, guitar worn low, contemporary dreamlike haze | Electric guitar worn low |
| Noise Rock | `#6E6A40` | Abrasive grimy olive-gray | Disheveled art-punk musician, messy hair, wrestling with their guitar (chaos/feedback), contorted body, unhinged grimace/scream | Electric guitar (being wrestled) |
| Noise Pop | `#B06880` | Bittersweet powdery rose-mauve | Cool detached musician, tousled hair, dark glasses, perfecto jacket, nonchalant guitar + feedback lines, charmingly jaded attitude | Sunglasses + electric guitar |
| Jazz | `#2C4A3E` | Deep pine green | Elegant middle-aged man, tilted fedora, suit jacket, discreet smile | Trumpet (rare, for Jazz solos) |
| Blues | `#3D2B1F` | Tobacco brown-black | Tired old man, battered hat, worn shirt, expressive wrinkles, melancholic gaze | Harmonica (rare) |
| Soul / R&B | `#7A3B69` | Deep plum mauve | Elegant woman, sequined dress, 60s retro hairstyle, expressive makeup | — |
| Funk / Groove | `#C07A1A` | Golden ochre | Man in a wide-lapel suit, flared shirt collar, afro hair, confident cool attitude | — |
| Hip-Hop / Rap | `#1A2A3A` | Navy midnight blue | Person in a hoodie pulled low, visible gold chain, direct camera gaze | — |
| Rap Rock / Rap Metal | `#33404E` | Urban slate blue-gray | Crossover rapper/rocker artist, backwards cap or cornrows, tank top + rock touch, tattoos, energetic flow pointing a finger | Microphone |
| Trip Hop / Downtempo | `#4A8B9A` | Steel teal | Serene person, short black hair, rust or maroon sweater, half-closed eyes | Over-ear headphones |
| Trip Hop 90s | `#3A5E64` | Smoky dusk teal-gray | Melancholic nocturnal figure, dark short/mid-length hair, introspective slightly sad gaze, large headphones, dark sweater | Over-ear headphones |
| Lo-Fi / Chill | `#7B6FA5` | Violet lavender | Relaxed person, messy bun, oversized sweatshirt, dreamy expression | Tea cup or headphones |
| Ambient / New Age | `#4A7A8B` | Ocean blue-green | Person with peaceful features, flowing loose clothing, meditative expression | — |
| Electronic / Techno | `#1A2040` | Electric midnight blue | Person with LED goggles or half-hidden face, rave jacket, focused attitude | — |
| House / Dance | `#C84B6B` | Vivid but muted pink-coral | Smiling person, shoulders moving, matte colorful clothing, free-flowing hair | — |
| Synthwave / Retro-wave | `#2D1B4E` | Deep night violet | Person in a bomber jacket, pink-tinted sunglasses, retro 80s haircut | — |
| Synthpop | `#C25A85` | Powdery 80s pink-magenta | 80s new-wave person, voluminous asymmetric hairstyle, shoulder-padded blazer, cool detached attitude | Keytar (or synth / new wave glasses) |
| New Wave | `#C85A5A` | Stylish coral-red | Chic, arty early-80s figure, asymmetric geometric haircut, thin tie/angular blazer, cool quirky detached attitude | — |
| Disco | `#A03A70` | Burgundy magenta | Flamboyant woman or man, disco suit, voluminous hair, dazzling smile | — |
| Reggae / Dub | `#2A6B3A` | Jungle green | Relaxed person, dreadlocks, rasta beanie, serene smile | — |
| Country | `#B5722A` | Copper amber | Person in a cowboy hat, western shirt, warm expression | — |
| Folk / Acoustic | `#6B8B5E` | Sage green | Person with long free-flowing hair, wool sweater, introspective air | — |
| Classical / Orchestral | `#4A3A6B` | Deep indigo | Elegant musician, bow tie, focused serious gaze | — |
| Twee Pop / Indie Pop | `#D9706B` | Rosy salmon | Cute young person, short hair with a bow or fringe, striped shirt, retro 60s look | — |
| Pop Rock | `#D06E4A` | Solar coral-orange | Charismatic smiling frontman, modern styled hair, cool-casual look, big unifying smile, singing into a mic | Microphone |
| Pop Punk | `#C24A78` | Punchy pop pink-magenta | Energetic playful youth, spiked hair or colored streak, band t-shirt, smirking/tongue-out smile, festive youthful energy | — |
| Bossa Nova / Samba | `#2A7A6B` | Muted emerald green | Relaxed, elegant person, light summer clothing, casual smile | — |
| Surf Rock | `#2E9698` | Sunny ocean turquoise | Tanned 60s surfer, bleached blond hair, Hawaiian shirt, big carefree smile | Surfboard (or vintage surf guitar) |
| Cool Summer Rock | `#D8834E` | Golden-hour coral-amber | Cool relaxed summer person, tousled golden hair, sunglasses, open shirt, relaxed sunny half-smile | Sunglasses |
| Progressive Rock & Metal | `#3A4A5A` | Cerebral slate blue-gray | Cerebral virtuoso, well-kept long hair, glasses, thoughtful intelligent gaze, epic technician aura | Double-neck guitar |
| Space Rock | `#1E2A4A` | Deep cosmic indigo-navy | Cosmic dreamer, retro bubble astronaut helmet, serene gaze toward distant stars | Astronaut helmet (+ small cream stars on background) |
| Grunge | `#4A3A2A` | Khaki brown | Tired person, unbuttoned plaid shirt over a t-shirt, messy unwashed hair | — |
| Post-rock | `#46586A` | Atmospheric dusk steel-blue | Absorbed introverted musician, mid-length hair, closed eyes or upward gaze, contemplative lost expression, guitar | Electric guitar |
| Post-punk | `#3A424E` | Pale cold blue-gray | Melancholic pale figure, dark eye makeup, dark backcombed messy hair, high-collar coat, moody detached gaze | — |
| Post-metal | `#2E3834` | Very dark gray-green basalt | Intense possessed musician, long hair + beard, head down or eyes closed, crushing contemplative gravity, guitar worn low | Electric guitar |
| Post-hardcore | `#2E6A62` | Vivid energetic green-teal | Expressive dynamic singer, messy bushy/curly hair, leaning forward, passionate singing between scream and melody | Microphone |
| Math Rock | `#3E7078` | Clean geometric teal-blue | Precise technical indie-emo musician, glasses, cardigan, tapping on guitar, focused slightly melancholic gaze | Electric guitar (tapping) |
| Mathcore | `#263834` | Very dark dissonant teal-charcoal | Musician mid unleashed technical chaos, hair flying, contorted/spasming body, scream, unhinged fury, wrestling guitar/mic | Guitar/mic (being wrestled) |
| Post-grunge | `#6A3E3A` | Warm sincere brown-maroon | "Everyman" singer, mid-length or short hair, 3-day beard/goatee, simple shirt, emotive dedicated singing | Microphone |
| Stoner Rock | `#954E2E` | Dusty desert terracotta | Laid-back man, long shaggy hair or beanie, big beard, half-closed hazy eyes, faded t-shirt, chill air | — |
| Sludge Metal | `#45472C` | Muddy swampy olive-green | Grimy hostile man, tangled greasy hair, big unkempt beard, grime/sweat, sleeveless jacket, tattooed arms, bitter air | — (option: whiskey bottle) |
| Visual Kei | `#4A2A50` | Deep plum-violet | Androgynous glam-gothic character, asymmetric spiked hairstyle + light-colored streak, dramatic eye makeup, high collar/choker/straps, theatrical expression | — (option: one accent-colored streak) |
| Viking Metal | `#3E5A60` | Cold Nordic blue-gray | Viking warrior, braided hair + beard (with beads), fur over the shoulders, war paint, fierce gaze | Drinking horn (mead) |
| Power Rock & Metal | `#2E6AA8` | Heroic royal blue | Heroic-fantasy musician, flowing flamboyant hair, hints of armor/cape, triumphant cry, brandishing a Flying-V toward the sky | Flying-V guitar (or sword) raised high |
| Pirate Metal | `#2A5658` | Deep ocean teal | Jovial pirate metalhead, tricorn hat + long hair + big beard, eyepatch, buccaneer coat, tipsy grin | Foaming beer mug |
| Pagan Metal | `#2E4A34` | Deep ancient forest-green | Tribal warrior-shaman, long wild braided hair, antler + fur headdress, ochre/blue tribal paint, fierce mystical gaze | Antler headdress (option: amulets/bones) |
| Medieval Rock & Metal | `#6E4E2E` | Amber-brown tavern | Minstrel-metalhead, long (braided) hair, laced medieval tunic/cape, playing a lute or hurdy-gurdy, jovial tavern spirit | Lute / hurdy-gurdy (or bagpipes) |
| Symphonic Rock & Metal | `#6E2A3A` | Deep velvet burgundy (opera) | Dramatic lyrical singer, long wavy hair, gothic corset dress, mid passionate singing | — (option: mic / violin) |
| Symphonic Rock 70s | `#443466` | Grandiose deep royal violet | 70s symphonic-prog showman, long hair, large flamboyant cape, majestic outfit, monumental keyboards, grandiose gesture | Keyboard/synthesizer (or cape) |
| Orchestral Rock & Metal | `#2E3A5A` | Deep concert-hall night-blue | Long-haired musician fusing classical and metal, playing cello with fervor, formal-rock outfit, epic passionate gesture | Cello + bow (or conductor/baton) |
| Opera Rock / Rock Opera | `#A0344E` | Theatrical magenta-red | Flamboyant performer, possible mustache, stage outfit, arm extended/hand on heart, grandiose theatrical singing | — (option: mic) |

---

## Section B — Situations / Activities

| Situation | Background (hex) | Color description | Archetype character | Prop |
|---|---|---|---|---|
| Cooking | `#D4874A` | Warm spicy orange | Enthusiastic cook, apron, focused joyful expression | Spatula or ladle |
| Running / Sport | `#3A7D44` | Dynamic green | Runner, sportswear, in-ear headphones, determined expression | — |
| Workout / Gym | `#C85A2A` | Energetic burnt orange | Athletic person, tank top, muscular shoulders, sweaty forehead, towel around neck, determined gaze | Dumbbell |
| Work / Focus / Office | `#4A5568` | Slate blue-gray | Focused person, glasses, diligent expression | Coffee cup |
| Reading / Relaxing | `#8B6F47` | Warm caramel brown | Absorbed person, comfortably dressed, serene expression | Book |
| Party | `#7A3A6B` | Festive mauve | Cheerful person, party outfit, festive smile | Glass (rare) |
| Meditation / Yoga | `#6B9A8B` | Water green | Person with closed eyes, loose comfortable clothing, calm expression | — |
| Driving / Road Trip | `#3A5A7A` | Nighttime road blue | Person at an imaginary wheel, sunglasses, free expression | — |
| Gaming | `#2A2A4A` | Night indigo | Focused person, gaming headset, intense forward gaze | Controller (rare) |
| Waking up / Morning | `#D4A040` | Golden honey yellow | Half-asleep person, messy hair, pajamas or sweatshirt | Big coffee cup |
| Cozy evening / Winter | `#6A3A2A` | Brick brown-red | Bundled-up person, blanket or thick sweater, soft warm expression | Hot chocolate cup |
| Celebration | `#C84B4B` | Muted festive red | Person in a party hat, wide smile, joyful mood | — |
| Nature / Hiking | `#4A6A3A` | Forest green | Person in a hiking beanie, outdoor jacket, gaze toward the horizon | — |
| Beach / Summer | `#D4A060` | Golden sand | Relaxed person, light clothing, sunny smile | — |
| Blue Noise / Focus | `#2E5A82` | Crisp true blue | Fully focused and alert person, sharp open eyes, focused gaze, headphones, sharp mind (alert focus — vs. calm White Noise focus) | Headphones |
| White Noise / Focus | `#8A9096` | Neutral light blue-gray | Focused, serene person, headphones, calm focus | Headphones |
| Pink Noise / Sleep | `#C08A9A` | Soft powder pink | Peacefully sleeping person, closed eyes, resting head, cream-colored "Zzz" | — (+ "Zzz") |
| Brown Noise / Relaxation | `#6E4A32` | Deep warm brown | Deeply relaxed person, leaning back, closed eyes, blissful, headphones | Headphones |
| Violet Noise / Tinnitus relief | `#6A4A80` | Muted violet | Soothed person, hand near the ear (relieved from ringing), serene half-closed eyes | — |
| Grey Noise / Calm | `#6E7074` | Medium neutral gray | Person in balanced calm, closed eyes, neutral serene face | — |
| Green Noise / Meditation | `#4E6B4A` | Muted moss green | Meditating person, closed eyes, serene, upright posture, hands in meditation position | — |
| Black Noise / Silence | `#1E1E20` | Near-total charcoal black | Person in absolute silence, closed eyes, motionless, finger in front of lips (shh) | — |

> **"XXX Noise For ..." family**: palette derived from the noise color (muted version), character adapted to the actual use (focus / sleep / relaxation / tinnitus / calm / meditation / silence). See also the note on colored-noise uses.
| Shared quiet moment (parent and child) | `#6B8B5E` | Sage green | Smiling parent + their young child beside them, affectionate and close (2 characters) | — |
| Coding / Backend Dev | `#2F4A44` | Dark pine green (terminal mood) | Backend dev, hoodie, glasses, headphones, 3-day beard, focused/absorbed | Coffee cup |
| Yuck (music you hate) | `#8B9A45` | Sickly acid olive-green | Person with an exaggerated comic disgust grimace, scrunched nose, tongue out, pulling out an earbud with a disgusted look | Removed earbud / phone held at arm's length |
| Reflection / Mourning | `#55606E` | Soft slate blue-gray | Reflective person, gently closed eyes, peaceful dignified restrained expression (never caricatural). Possible variant with no character: a simple centered white flower or candle | White flower (lily/rose) |

---

---

## Section C — Hybrids (situation × genre)

Playlists that cross a life moment with a musical style. Principle: merge the context (e.g. waking up = messy hair + coffee) with the genre's marker (e.g. the rock/metal horns).

| Playlist | Background (hex) | Color description | Archetype character | Prop |
|---|---|---|---|---|
| Wake up Rock | `#D89A3A` | Golden amber (sunrise) | Person waking up, tousled hair, rock t-shirt, rock horns, big awake smile | Coffee cup + horns 🤘 |
| Wake up Heavy Metal | `#C0552A` | Intense burnt orange (sunrise) | Metalhead waking up, long messy hair, morning scream, metal horns, intense/sleepy expression | Coffee cup + horns 🤘 |
| Wake up (Rock + Metal fusion) | `#CC7830` | Warm amber-orange (between the two Wake-up tones) | 2 characters: a rocker (tousled hair, rock t-shirt) + a metalhead (long messy hair), both with raised horns and coffee in hand, awake and in sync | Coffee cup + horns 🤘 (×2) |
| Workout Stoner (Gym × Stoner Rock) | `#B0552E` | Warm orange-terracotta (between Workout and Stoner) | Muscular man lifting a dumbbell but with the relaxed/floaty stoner attitude: long hair or headband, beard, tank top, blissful half-closed eyes (comic effort/zen mismatch) | Dumbbell |
| Workout Screamo (Gym × Screamo) | `#5A3A2E` | Intense dark umber-brown (between Workout and Screamo) | Muscular man mid-effort screaming like a screamo singer: tank top, dumbbell, wide-open mouth, clenched eyes, neck tension, sweaty emo fringe | Dumbbell — option: screaming into it like a mic |
| Workout Rock (Gym × Rock) | `#C87A2E` | Warm golden orange-amber | Muscular man mid-effort, rock energy: band tank top, dumbbell in one hand + rock horns in the other, big festive yell, rockstar-style tongue out | Dumbbell + horns 🤘 |
| Workout Punk Metal (Gym × Punk Metal) | `#4A2A3E` | Aggressive dark plum-violet | Muscular man mid-effort, punk-metal energy: mohawk or shaved sides, studs, tattoos, torn tank top, dumbbell, enraged bared-teeth snarl | Dumbbell |
| Workout (bhangra-inspired) (Gym × celebratory pop) | `#C4A030` | Festive marigold-saffron yellow | Muscular man, neat turban + beard, tank top, dumbbell in one hand + a raised celebratory arm gesture in the other, big radiant proud smile | Dumbbell + celebratory arm gesture |
| Workout Pop Punk (Gym × Pop Punk) | `#C24A78` | Punchy pop pink-magenta | Energetic young athlete, spiked hair or colored streak, band t-shirt, dumbbell, smirking/tongue-out smile, festive youthful energy | Dumbbell |
| Workout Punk 90s (Gym × 90s Punk) | `#3E8E4A` | Vivid energetic 90s green | Energetic athlete with a 90s SoCal punk spirit, bleached spiked/liberty-spike hair, band tank top, tattoos, dumbbell, smirking smile | Dumbbell |
| Angry Workout (Gym × rage rock/metal) | `#9A2E2E` | Deep aggressive blood red | Athlete in explosive rage, mid/long hair, tank top, dumbbell, furious face: clenched-teeth roar, bulging veins, furrowed brow | Dumbbell |
| Angry Workout Punk (Gym × rage × Punk) | `#7E2A34` | Dark aggressive crimson-maroon | Enraged athlete, punk look: mohawk/spikes, studded bracelets, tattoos, torn tank top, dumbbell, fury-screaming face | Dumbbell |
| Extreme Workout Death Metal (extreme Gym × Death Metal) | `#2A1618` | Very dark blood-black | Athlete at maximum effort, long hair whipping, shadowed eyes, very heavy dumbbell, strained muscles, death-growl roar, veins bulging everywhere | Heavy dumbbell |
| Workout Metalcore (Gym × Metalcore) | `#3A5058` | Cold dark steel-teal | Muscular man, metalcore look (undercut, ear gauges, neck/arm tattoos, short beard, black tank top), dumbbell, hard gaze, clenched jaw | Dumbbell |
| Workout Heavy Metal (Gym × Heavy Metal) | `#3E4650` | Gunmetal steel-gray | Epic muscular metalhead, long hair, studded leather, dumbbell in one hand + metal horns in the other, powerful stance/warrior cry | Dumbbell + horns 🤘 |
| Workout Alternative Rock & Metal (Gym × Alt Rock/Metal) | `#40543E` | Moody dark forest-green (grunge/alt) | Raw authentic athletic rocker, mid-length messy hair, stubble, simple tank top, dumbbell, intense lived-in gaze (no artifice) | Dumbbell |
| Workout (UMBRELLA — groups all rock/metal Workout entries except the bhangra one) | `#C85A2A` | Burnt orange (mother color of the Workout series) | 2 characters: long-haired metalhead (dumbbell + horns) + tattooed undercut athlete (dumbbell, determined smirk), explosive in-sync rock/metal energy | Dumbbells (×2) + horns 🤘 |
| Studying Soft Rock (Studying × Soft Rock) | `#A67650` | Warm felted caramel-brown | Person studying calmly, 70s feathered hair, glasses/light mustache, headphones, bent over notes, relaxed and focused | Book/notes + headphones |
| Studying Rock (Studying × Rock) | `#A65440` | Warm rust-brick | Person studying with rock energy, mid-length hair, band t-shirt, headphones, focused on notes with a slight head-nod | Book/notes + headphones |
| Studying Rock 'n' Roll (Studying × Rock 'n' Roll) | `#B0842E` | Warm retro mustard-gold | 50s-style student, slicked pompadour, retro shirt with rolled sleeves, headphones, focused on notes, diligent but cool | Book/notes + headphones |
| Studying Progressive Rock (Studying × Prog Rock) | `#3E5460` | Cerebral slate blue-gray | Person in intense cerebral study, well-kept long hair, glasses, headphones, hand on chin, deep reflection over notes | Book/notes + headphones |
| Studying Progressive Metal (Studying × Prog Metal) | `#34464E` | Deep dark steel-teal | Person in intense technical study, long hair, band t-shirt, headphones, near-mathematical concentration, clenched jaw over notes | Book/notes + headphones |
| Studying Metalcore (Studying × Metalcore) | `#2A4E4E` | Dark steel-teal | Person studying with metalcore intensity, undercut (full on top), ear gauges, tattoos, headphones, hard focused gaze on notes | Book/notes + headphones |
| Studying Metal (Studying × Metal, generic) | `#3A3E44` | Neutral dark gunmetal gray | Classic metalhead revising, long hair, black band t-shirt, headphones, intense serious concentration on notes | Book/notes + headphones |
| Studying Melodic Metal (Studying × Melodic Metal) | `#3A4866` | Melancholic dusk indigo-blue | Person studying, concentration tinged with emotion, long hair, band t-shirt, headphones, absorbed, slightly moved/dreamy gaze | Book/notes + headphones |
| Studying Chill Rock (Studying × Chill Rock) | `#5E8078` | Soft soothing sage-teal green | Person studying in relaxed mode, soft hair, big sweater, headphones, relaxed posture, light calm smile, warm cup nearby | Book/notes + headphones + warm cup |
| Studying Indie Rock (Studying × Indie Rock) | `#52667E` | Understated dusty denim-blue | Person studying with an arty hipster style, tousled hair or beanie, glasses, cardigan/plaid, headphones, composed bohemian focus | Book/notes + headphones |
| Studying Math Rock (Studying × Math Rock) | `#3E6E6A` | Clean geometric teal-green | Meticulous person studying, glasses, cardigan, headphones, tapping a rhythm with fingers/pencil on notes, precise nerdy focus | Book/notes + headphones + pencil tapping |
| Studying Instrumental Rock (Studying × Instrumental Rock) | `#4A4658` | Immersive neutral gray-plum | Person fully immersed in studying (no lyrics = maximum focus), mid-length hair, headphones, deep concentration or eyes closed savoring a guitar solo | Book/notes + headphones |
| Studying Heavy Metal (Studying × Heavy Metal) | `#3A4E62` | Chrome steel-blue | Classic metalhead revising, long hair, denim/leather battle vest with patches, headphones, intense epic concentration on notes | Book/notes + headphones |
| Studying Death Metal (Studying × Death Metal) | `#26201F` | Near-total brown-black | Metalhead revising, long dark hair, spiky-logo death-metal t-shirt, headphones, fierce concentration matching the brutality (furrowed brow, clenched jaw) | Book/notes + headphones |
| Studying Alternative Rock (Studying × Alt Rock) | `#46584E` | Moody sage green-gray | Person studying with a 90s alt spirit, mid-length hair, possible glasses, plaid/simple t-shirt, headphones, composed introspective focus | Book/notes + headphones |
| Studying (UMBRELLA — groups all rock/metal Studying entries) | `#4A5568` | Slate blue-gray (mother color of "Work/Focus") | 2 characters: a rocker (mid-length hair, rock t-shirt, headphones, book) + a metalhead (long hair, black t-shirt, headphones, notes), studious, absorbed and in sync | Books/notes (×2) + headphones |
| Focus Studying (Focus × light rock) | `#3A5A60` | Calm focused teal-blue | Person in deep calm concentration, mid-length hair, discreet band t-shirt, headphones, serene absorbed gaze on notes (light rock touch) | Book/notes + headphones |

---

## Section D — Tempo / BPM

Playlists tuned to a tempo (often for running/cardio — e.g. 160-180 BPM = stride cadence). Sports character in motion + genre marker + a small cream "pulse/beat" element.

| Playlist | Background (hex) | Color description | Archetype character | Prop |
|---|---|---|---|---|
| Rock Metal 160 BPM | `#C24E2E` | Pulsing energetic orange-red | Rock/metal-boosted runner, mid-length hair in motion, band tank top, headphones, sweat, dynamic stride, motion lines | Headphones + cream heartbeat-pulse line on background |
| Workout 180 BPM | `#C23A54` | Intense warm crimson-magenta | High-intensity athlete in explosive effort/sprint, hair in motion, tank top, headphones, flying sweat, marked motion lines | Headphones + tight cream pulse line on background |

## Automatic detection rules

**Musical genre** → if the name evokes a music style, a subgenre, an artist, a dominant instrument.
**Situation** → if the name evokes an activity, a time of day, a place, a non-musical state of mind.

**Ambiguous cases:**
- "Workout" → Section B (Running/Sport)
- "Chill" → Section A (Lo-Fi/Chill)
- "Party" → Section B (Party)
- "Concentration" → Section B (Work/Focus)
- "Sleep" → Section A (Ambient) or Section B (Meditation) depending on context

**Extending the catalog:**
If a playlist doesn't match any entry, create an ad hoc entry and add it at the bottom of the relevant section.
