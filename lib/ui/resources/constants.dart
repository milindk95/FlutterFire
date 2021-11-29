part of 'resources.dart';

/// API URL
const liveUrl = 'https://api.thesuper11.com/api/v1/';
const stagingUrl = 'http://35.154.225.92/api/v1/';
const localUrl = 'http://192.168.1.24:5000/api/v1/';

/// Validation errors
const passwordError = 'Password requires at least 6 characters';

/// URL
const baseUrl = 'https://thesuper11.com/';
const aboutUsUrl = baseUrl + 'about.html';
const howToPlayUrl = baseUrl + 'how-to-play-cricket.html';
const howToWithdrawUrl = baseUrl + 'how-to-withdraw.html';
const fantasyPointUrl = baseUrl + 'fantasy-point.html';
const termsAndConditionsUrl = baseUrl + 'terms-and-conditions.html';
const privacyPolicyUrl = baseUrl + 'privacy-policy.html';
const helpUrl = baseUrl + 'help.html';
const howToInstallUrl = baseUrl + 'how-to-Install.html';
const appStoreUrl = 'https://apps.apple.com/in/app/thesuper11/id1562642636';
const androidApkUrl = baseUrl + 'download/thesuper11.apk';

/// Confirmations
String getConfirmation(String type, String mobileNoOrEmail) =>
    '6 Digits OTP will send to your $type "$mobileNoOrEmail".';

/// Share
String getShareMessage(String referralCode, {bool whatsapp = false}) =>
    howToInstallUrl +
    "\nJoin the TheSuper11 community by simply downloading our application from above link. "
        "On joining, earn up to ₹100 Rewards in your TheSuper11 wallet as a joining reward. "
        "\nUse Referral Code: " +
    (whatsapp ? '*$referralCode*' : referralCode);

/// Notes
const panCardAndBankVerificationNotes =
    'Please fill the following information correctly. Image details and filled information must be same.';

/// Arrays
const availableStates = [
  'Arunachal Pradesh',
  'Bihar',
  'Chhattisgarh',
  'Goa',
  'Gujarat',
  'Haryana',
  'Himachal Pradesh',
  'Jharkhand',
  'Karnataka',
  'Kerala',
  'Madhya Pradesh',
  'Maharashtra',
  'Manipur',
  'Meghalaya',
  'Mizoram',
  'Punjab',
  'Rajasthan',
  'Tripura',
  'Uttarakhand',
  'Uttar Pradesh',
  'West Bengal',
  'Andaman and Nicobar Islands',
  'Chandigarh',
  'Dadra and Nagar Haveli and Daman & Diu',
  'Delhi',
  'Jammu and Kashmir',
  'Ladakh',
  'Lakshadweep',
  'Puducherry',
];

const genders = ['Male', 'Female', 'Other'];

/// Match status
const matchNotStarted = 'not_started';
const matchStarted = 'started';
const matchCompleted = 'completed';
const matchAbandoned = 'abandoned';
const matchPostponed = 'postponed';

/// Transaction type
const transactionTypeWithdraw = 'withdraw';
const transactionTypeJoinedContest = 'joined contest';
const transactionTypeSuccess = 'success';
const transactionTypeDeposit = 'deposit';

/// Transaction status
const transactionStatusSuccess = 'success';
const transactionStatusRejected = 'rejected';

/// Contest type
const megaContest = 'mega contest';
const hotContest = 'hot contest';
const headToHeadContest = 'head to head';
const practiceContest = 'practice contest';
const winnerTakesAllContest = 'winner takes all contest';

/// PAN Card status
const panCardPending = 'pending';

/// Player roles
const playerTypes = ['Wicket Keepers', 'Batsman', 'All Rounders', 'Bowlers'];
const playerRoles = ['keeper', 'batsman', 'rounder', 'bowler'];

/// Add money minimum amount
const addMoneyMinimumAmount = 50.0;

/// Maximum contest joined message
const maximumContestJoined = 'You already joined this contest maximum times.';

/// Default color for teams
const team1Color = Colors.orangeAccent;
const team2Color = Colors.blueAccent;

/// Player Stats
const playerStats = [
  'Runs',
  'Fours',
  'Sixes',
  'Fifties',
  'Hundreds',
  'Duck',
  'Wickets',
  '4-Wickets',
  '5-Wickets',
  'Maiden Over',
  'Catch',
  'Stumping',
  'Run Out',
  'Economy',
  'Strike Rate'
];
const t10PointDivider = [0.5, 0.5, 1, 4, 8, 2, 10, 4, 8, 4, 4, 6, 4, 1, 1];
const t20PointDivider = [0.5, 0.5, 1, 4, 8, 2, 10, 4, 8, 4, 4, 6, 4, 1, 1];
const oneDayPointDivider = [0.5, 0.5, 1, 2, 4, 3, 12, 2, 4, 2, 4, 6, 4, 1, 1];
const testPointDivider = [0.5, 0.5, 1, 2, 4, 4, 8, 2, 4, 1, 4, 6, 4, 1, 1];

const matchT10 = 't10';
const matchT20 = 't20';
const matchOneDay = 'one-day';
const matchTest = 'test';
