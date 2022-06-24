<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\MarchendiseController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\FavoritController;
use App\Http\Controllers\API\PesananController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/get-all-marchendise', [MarchendiseController::class, 'index']);
Route::post('/tambah-marchendise', [MarchendiseController::class, 'tambahMarchendise']);
Route::get('/get-marchendise-by-id/{marchendise_id}', [MarchendiseController::class, 'detailMarchendise']);
Route::post('/edit-marchendise/{marchendise_id}', [MarchendiseController::class, 'editMarchendise']);
Route::get('/delete-marchendise/{marchendise_id}', [MarchendiseController::class, 'hapusMarchendise']);
Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);
Route::post('/edit-profile/{user_id}', [UserController::class, 'editProfile']);
Route::get('/get-user/{user_id}', [UserController::class, 'getUser']);
Route::post('/tambah-favorit/{user_id}/{marchendise_id}', [FavoritController::class, 'tambahFavorit']);
Route::get('/get-marchendise-favorit/{user_id}/', [FavoritController::class, 'getMarchendiseFavorit']);
Route::post('/delete-marchendise-favorit/{user_id}/{marchendise_id}/', [FavoritController::class, 'hapusFavorit']);
Route::post('/bayar/{user_id}/{marchendise_id}/', [PesananController::class, 'buatPesanan']);
Route::get('/riwayat-pesanan/{user_id}/', [PesananController::class, 'riwayatPesanan']);
Route::get('/pesanan-masuk', [PesananController::class, 'pesananMasuk']);
Route::get('/cari-marchendise/{value}', [MarchendiseController::class, 'getMarchendiseBySearch']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
