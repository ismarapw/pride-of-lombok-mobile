<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Models\Marchendise;
use App\Helpers\ApiFormatter;
use App\Http\Controllers\Controller;
use Exception;
use Illuminate\Support\Facades\Validator;

class MarchendiseController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $data = Marchendise::all();

        if($data) {
            return ApiFormatter::createApi(200, 'success', $data);
        }else {
            return ApiFormatter::createApi(400, 'failed');
        }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
      
        // validasi data
        $validated_data = Validator::make($request->all(), [ 
            'nama' =>'required|max:128',
            'jenis' =>'required|max:128',
            'deskripsi' =>'required|max:5000',
            'harga' =>'required|integer|digits_between:1,20',
            'gambar' => 'required|mimes:jpg,bmp,png'
        ]);

        if($validated_data->fails()){
            return ApiFormatter::createApi(200, 'Success', $validated_data->errors()); 
        }else {
              // Upload gambar 
              $file = $request->file('gambar');
              $file_name = $file->getClientOriginalName();
              $file->move(public_path('/images/marchendise/'), $file_name); 
      
              // Buat object data marchendise
              $marchendise = new Marchendise();
      
              $marchendise->nama = $validated_data['nama'];
              $marchendise->jenis = $validated_data['jenis'];
              $marchendise->deskripsi = $validated_data['deskripsi'];
              $marchendise->harga = $validated_data['harga'];
              $marchendise->gambar = $file_name;
      
              # save data
              $marchendise->save();

              return ApiFormatter::createApi(200, 'Success', $marchendise); 
        }
 
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
