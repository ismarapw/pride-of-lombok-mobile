<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Helpers\ApiFormatter;
use App\Models\Favorit;
use Illuminate\Support\Facades\DB;

class FavoritController extends Controller
{
    public function getMarchendiseFavorit($idUser){
        $favorit = DB::select(
            "select marchendise.id as merch_id, marchendise.nama, 
             marchendise.jenis, marchendise.harga, marchendise.gambar,favorit.id as fav_id
             from favorit, marchendise, users 
             where favorit.user_id = users.id and 
             favorit.marchendise_id = marchendise.id and 
             favorit.user_id = $idUser"
        );

        return ApiFormatter::createApi(200, 'Sucess', $favorit); 
    }

    public function tambahFavorit($idUser, $idMarchendise){
         // Cek apakah barang sudah ditambahkan atau belum oleh user
         $barang_favorit = DB::select("select id from favorit where user_id = $idUser and marchendise_id = $idMarchendise");

         if($barang_favorit == true){
             // jika barang sudah ada di favorit kembalikan ke halaman detail dan beri pesan
             return ApiFormatter::createApi(300, 'Failed', 'Barang sudah ada di Favorit'); 
         }else{
             //  jika barang belum ada di favorit, insert-kan barang menjadi favorit
 
             // Buat object favorit
             $new_fav = new Favorit();
 
             $new_fav->user_id = $idUser;
             $new_fav->marchendise_id = $idMarchendise;
 
             // insert ke database (save)
             $new_fav->save();
 
             return ApiFormatter::createApi(200, 'Success', 'Barang berhasil ditambahkan ke Favorit');
         } 

    }


    public function hapusFavorit($idUser, $idMarchendise){
        $delete = DB::delete("delete from favorit where user_id = $idUser and marchendise_id = $idMarchendise");

        return ApiFormatter::createApi(200, 'Success', 'Barang berhasil diapus dari favorit');
    }


}

?>