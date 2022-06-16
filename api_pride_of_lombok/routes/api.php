<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\MarchendiseController;

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

Route::get('/home', [MarchendiseController::class, 'index']);
Route::post('/store', [MarchendiseController::class, 'store']);
Route::get('/show/{id}', [MarchendiseController::class, 'show']);
Route::post('/edit/{id}', [MarchendiseController::class, 'edit']);


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
