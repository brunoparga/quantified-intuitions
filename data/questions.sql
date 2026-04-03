-- Insert Challenge
INSERT INTO "Challenge" (id, name, subtitle, "startDate", "endDate", unlisted, "isDeleted", "createdAt")
VALUES (
  'giving-tuesday-2024',
  'Annetamistalgud - annetamisviktoriin',
  'Giving Tuesday Quiz 2024',
  '2024-11-26 00:00:00',
  '2024-12-03 23:59:59',
  false,
  false,
  CURRENT_TIMESTAMP
);

-- Insert Fermi questions (1-8)
INSERT INTO "CalibrationQuestion" (id, content, answer, prefix, postfix, source, "useLogScoring", "isDeleted", "challengeOnly", "C", context)
VALUES
  (
    'q1-annabel',
    '2019. a juunis tehti üleskutse koostöös Lastefondiga toetada 2 kuu vanust Annabeli, kellel diagnoositi spinaalne lihasatroofia, mille ainus potentsiaalne ravi oli saadaval USAs - geeniravim Zolgensma. Kui suur summa koguti mõne nädalaga kokku?

In June 2019, there was a campaign to help 2-month-old Annabel who was diagnosed with spinal muscle atrophy, with the only potential cure being the gene therapy drug Zolgensma. How much money was donated during 2-3 weeks?',
    2200000.0,
    '',
    ' EUR',
    'https://ekspress.delfi.ee/artikkel/86645049/annabel-lendab-ameerikasse-viimase-puudu-olnud-280-000-eurot-annetas-eesti-arimees',
    true,
    false,
    true,
    100,
    ''
  ),
  (
    'q2-happiness',
    'Mis skoori (0-10) sai Eesti 2025. a Maailma Õnnelikkuse Raporti järgi (andmed 2022-2024)?

According to World Happiness Report 2025 (based on data 2022-2024) what overall score did Estonia get (scale 0-10)?',
    6.417,
    '',
    '/10',
    'https://www.worldhappiness.report/',
    false,
    false,
    true,
    100,
    ''
  ),
  (
    'q3-wealth',
    'Mitme protsendi maailma kõige rikkama hulka kuulub Eestis mediaanpalka teeniv inimene (ühe inimese leibkond)?

What percentage of the world''s population is richer than an Estonian earning median wage (living in a one person household)?',
    7.3,
    '',
    '%',
    'http://kuirikassaoled.annetatargalt.ee',
    false,
    false,
    true,
    100,
    ''
  ),
  (
    'q4-donations-ee',
    'Mitu miljonit eurot annetati aastal 2023 Eestis vabaühendustele?

How much was donated to Estonian NGOs in 2023?',
    77700000.0,
    '',
    ' EUR',
    '',
    true,
    false,
    true,
    100,
    ''
  ),
  (
    'q5-givewell',
    'GiveWelli 2022-2024 hinnangute järgi, kui palju maksab ühe elu päästmine New Incentives'' rahaülekannete programmi abil, et muuta laste vaktsineerimine ligipääsetavaks kõige kulutõhusamates Nigeeria piirkondades (dollarites)?

According to GiveWell''s 2022-2024 estimates, what does it cost to save a life through New Incentives'' vaccination incentive program in the most cost-effective states in Nigeria (in USD)?',
    1500.0,
    '$',
    '',
    'https://www.givewell.org/international/technical/programs/new-incentives',
    true,
    false,
    true,
    100,
    ''
  ),
  (
    'q6-poverty-world',
    'Kui suur osa maailma populatsioonist elab allpool vaesuspiiri $8.30/päev?

What percentage of the world''s population lives on less than $8.30 a day?',
    45.5,
    '',
    '%',
    'https://ourworldindata.org/grapher/share-living-with-less-than-550-int--per-day',
    false,
    false,
    true,
    100,
    ''
  ),
  (
    'q7-poverty-ee',
    'Kui suur osa eestlastest elab allpool vaesuspiiri $8.30/päev?

What percentage of Estonian population lives on less than $8.30 a day?',
    1.3,
    '',
    '%',
    'https://ourworldindata.org/grapher/share-living-with-less-than-550-int--per-day',
    false,
    false,
    true,
    100,
    ''
  ),
  (
    'q8-giving-tuesday',
    'Kui palju annetusi koguti 2024. a annetamistalgute raames?

How much money was raised during Estonia''s Giving Tuesday campaign in 2024?',
    170630.0,
    '',
    ' EUR',
    'https://www.heakodanik.ee/uudised/annetamistalgud-2024-kuidas-laks/',
    true,
    false,
    true,
    100,
    ''
  );

-- Link Fermi questions to challenge
INSERT INTO "_CalibrationQuestionToChallenge" ("A", "B")
VALUES
  ('q1-annabel', 'giving-tuesday-2024'),
  ('q2-happiness', 'giving-tuesday-2024'),
  ('q3-wealth', 'giving-tuesday-2024'),
  ('q4-donations-ee', 'giving-tuesday-2024'),
  ('q5-givewell', 'giving-tuesday-2024'),
  ('q6-poverty-world', 'giving-tuesday-2024'),
  ('q7-poverty-ee', 'giving-tuesday-2024'),
  ('q8-giving-tuesday', 'giving-tuesday-2024');

-- Insert Above/Below questions (9-12)
INSERT INTO "AboveBelowQuestion" (id, content, quantity, "preciseAnswer", "answerIsAbove", source, "isDeleted")
VALUES
  ('q9-wgi-rank', 'According to World Giving Index (2024) how high does Estonia rank out of 142 countries with data available?', '71', '84', true, 'https://www.cafonline.org/insights/research/world-giving-index', false),
  ('q10-foodbank', 'How many tons of food did the Estonian Foodbank distribute in 2024?', '3000t', '4400t', true, 'https://www.toidupank.ee/', false),
  ('q11-gwwc-pledge', 'As of November 2025, how many people have taken the 10% Pledge (formerly Giving What We Can Pledge) to donate at least 10% of their lifetime income to effective charities?', '18,750', '10,259', false, 'https://www.givingwhatwecan.org/pledge', false),
  ('q12-undernutrition', 'What percentage of deaths of children under 5yr is linked to undernutrition?', '29%', '45%', true, 'https://www.unicef.org/documents/when-it-matters-most', false);

-- Link Above/Below questions to challenge
INSERT INTO "_AboveBelowQuestionToChallenge" ("A", "B")
VALUES
  ('q9-wgi-rank', 'giving-tuesday-2024'),
  ('q10-foodbank', 'giving-tuesday-2024'),
  ('q11-gwwc-pledge', 'giving-tuesday-2024'),
  ('q12-undernutrition', 'giving-tuesday-2024');