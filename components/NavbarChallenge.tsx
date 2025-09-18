import Link from "next/link";
import { useRouter } from "next/router";

import { Disclosure } from "@headlessui/react";
import {
  Bars3Icon, ScaleIcon, XMarkIcon
} from "@heroicons/react/24/outline";

export const NavbarChallenge = () => {
  const { pathname } = useRouter();
  const navigation = [];
  
  return (
    <Disclosure as="nav" className="bg-white border-b border-gray-200">
      {({ open }) => (
        <>
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between h-16">
              <div className="flex">
                <div className="-ml-2 mr-2 flex items-center lg:hidden">
                  {/* Mobile menu button */}
                  <Disclosure.Button className="bg-white inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    <span className="sr-only">Open main menu</span>
                    {open ? (
                      <XMarkIcon className="block h-6 w-6" aria-hidden="true" />
                    ) : (
                      <Bars3Icon className="block h-6 w-6" aria-hidden="true" />
                    )}
                  </Disclosure.Button>
                </div>
                <div className="flex-shrink-0 flex items-center">
                  <Link href="/">
                    <a className="prose">
                      <div className="flex items-center">
                        <ScaleIcon className="w-8 h-8 text-indigo-600" />
                        <h3 className="m-0 ml-2">Quantified Intuitions</h3>
                      </div>
                    </a>
                  </Link>
                </div>
              </div>
              <div className="flex">
                <div className="hidden lg:-my-px lg:ml-6 lg:flex lg:items-center">
                  <h1 className="text-xl font-semibold text-gray-900">The Estimation Game</h1>
                </div>
              </div>
            </div>
          </div>

          <Disclosure.Panel className="lg:hidden">
            <div className="pt-2 pb-3 space-y-1">
              <div className="pl-3 pr-4 py-2">
                <h1 className="text-lg font-semibold text-gray-900">The Estimation Game</h1>
              </div>
            </div>
          </Disclosure.Panel>
        </>
      )}
    </Disclosure>
  );
};